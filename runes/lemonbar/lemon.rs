use std::{
    collections::HashMap,
    convert::TryFrom,
    env,
    ffi::OsStr,
    fmt::{self, Display, Write},
    fs,
    io::{self, BufRead, BufReader, Write as _},
    ops::{Index, IndexMut},
    process::{Child, ChildStdin, Command, Stdio},
    str::{self, FromStr},
    sync::{mpsc, Arc, RwLock},
    thread::{self, Thread},
    time::Duration,
};

extern "C" {
    fn signal(sig: i32, handler: extern "C" fn(i32)) -> extern "C" fn(i32);
}

type ParseError<'a> = (&'a str, &'a str);

#[derive(Debug)]
struct Color<'a>(&'a str);

impl Default for Color<'static> {
    fn default() -> Self {
        Color("-")
    }
}

impl<'a> Display for Color<'a> {
    fn fmt(&self, fmt: &mut fmt::Formatter) -> fmt::Result {
        write!(fmt, "{}", self.0)
    }
}

impl<'a> Color<'a> {
    fn from_str(s: &'a str) -> Result<Self, &'static str> {
        if !s.starts_with('#') {
            return Err("Invalid colour");
        }
        if s[1..]
            .bytes()
            .all(|b| (b'0' <= b && b <= b'F' && b != b'@') || (b'a' <= b && b <= b'f'))
        {
            Ok(Color(s))
        } else {
            Err("Invalid character in colour")
        }
    }
}

#[derive(Debug, Copy, Clone, PartialEq, Eq, Hash)]
enum Alignment {
    Left,
    Middle,
    Right,
}

impl FromStr for Alignment {
    type Err = &'static str;
    fn from_str(s: &str) -> Result<Self, <Self as FromStr>::Err> {
        match s {
            "left" | "Left" => Ok(Self::Left),
            "middle" | "Middle" => Ok(Self::Middle),
            "right" | "Right" => Ok(Self::Right),
            _ => Err("Invalid alignment"),
        }
    }
}

#[derive(Debug)]
enum Content<'a> {
    Static(&'a str),
    Cmd {
        cmd: &'a str,
        last_run: OneOrMore<RwLock<String>>,
    },
    Persistent {
        cmd: &'a str,
        last_run: OneOrMore<Arc<RwLock<String>>>,
    },
}

impl<'a> Content<'a> {
    #![allow(dead_code)]
    fn cmd(&self) -> &str {
        match self {
            Self::Static(s) => s,
            Self::Cmd { cmd, .. } => cmd,
            Self::Persistent { cmd, .. } => cmd,
        }
    }

    fn update(&self) {
        if let Self::Cmd { cmd, last_run } = self {
            for m in 0..last_run.len() {
                match Command::new("sh")
                    .args(&["-c", cmd])
                    .env("MONITOR", m.to_string())
                    .stdout(Stdio::piped())
                    .stderr(Stdio::inherit())
                    .spawn()
                    .and_then(|c| c.wait_with_output())
                    .and_then(|o| {
                        if o.status.success() {
                            Ok(o.stdout)
                        } else {
                            Err(io::Error::from(io::ErrorKind::InvalidInput))
                        }
                    })
                    .map_err(|e| e.to_string())
                    .and_then(|o| String::from_utf8(o).map_err(|e| e.to_string()))
                    .map(|mut l| {
                        if let Some(i) = l.find('\n') {
                            l.truncate(i);
                            l
                        } else {
                            l
                        }
                    }) {
                    Ok(o) => *(last_run.index(m).write().unwrap()) = o,
                    Err(e) => *(last_run.index(m).write().unwrap()) = e,
                }
            }
        }
    }

    fn is_empty(&self, monitor: usize) -> bool {
        match self {
            Self::Static(s) => s.is_empty(),
            Self::Cmd { last_run, .. } => last_run[monitor].read().unwrap().is_empty(),
            Self::Persistent { last_run, .. } => last_run[monitor].read().unwrap().is_empty(),
        }
    }

    fn replicate_to_mon(mut self, n_monitor: usize) -> Self {
        match &mut self {
            Self::Cmd { last_run, .. } => last_run.resize_with(n_monitor, Default::default),
            Self::Persistent { last_run, .. } => last_run.resize_with(n_monitor, Default::default),
            _ => (),
        }
        self
    }
}

#[derive(Debug)]
enum OneOrMore<T> {
    One(T),
    More(Vec<T>),
}

impl<T: Default> Default for OneOrMore<T> {
    fn default() -> Self {
        Self::One(Default::default())
    }
}

impl<T> Index<usize> for OneOrMore<T> {
    type Output = T;
    fn index(&self, i: usize) -> &T {
        match self {
            Self::One(t) => t,
            Self::More(m) => &m[i],
        }
    }
}

impl<T> IndexMut<usize> for OneOrMore<T> {
    fn index_mut(&mut self, i: usize) -> &mut T {
        match self {
            Self::One(t) => t,
            Self::More(m) => &mut m[i],
        }
    }
}

impl<T> OneOrMore<T> {
    fn len(&self) -> usize {
        match self {
            Self::One(_) => 1,
            Self::More(m) => m.len(),
        }
    }

    fn iter(&self) -> Iter<T> {
        match self {
            Self::One(t) => Iter::One(Some(t)),
            Self::More(m) => Iter::More(m.iter()),
        }
    }

    fn resize_with<F>(&mut self, new_len: usize, f: F)
    where
        F: FnMut() -> T,
    {
        if new_len > 1 {
            let mut to_resize = match std::mem::replace(self, OneOrMore::More(vec![])) {
                Self::One(o) => vec![o],
                Self::More(m) => m,
            };
            to_resize.resize_with(new_len, f);
            *self = Self::More(to_resize);
        }
    }
}

#[derive(Debug)]
enum Iter<'a, T> {
    One(Option<&'a T>),
    More(std::slice::Iter<'a, T>),
}

impl<'a, T> Iterator for Iter<'a, T> {
    type Item = &'a T;
    fn next(&mut self) -> Option<Self::Item> {
        match self {
            Self::One(t) => t.take(),
            Self::More(m) => m.next(),
        }
    }
}

#[derive(Debug, Clone, Copy)]
enum Layer {
    All,
    L(u16),
}

impl PartialEq for Layer {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Self::All, _) => true,
            (_, Self::All) => true,
            (Self::L(l1), Self::L(l2)) => l1 == l2,
        }
    }
}

impl Layer {
    fn next(&mut self, bound: u16) {
        *self = match self {
            Self::L(n) => Self::L((*n + 1) % bound),
            Self::All => panic!("Can't next an all layer"),
        }
    }
}

impl Default for Layer {
    fn default() -> Self {
        Self::All
    }
}

impl FromStr for Layer {
    type Err = &'static str;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "all" | "All" => Ok(Self::All),
            s => match s.parse::<u16>() {
                Ok(n) => Ok(Self::L(n)),
                _ => Err("Invalid layer"),
            },
        }
    }
}

#[derive(Debug)]
struct DisplayContent<'a, 'b: 'a>(&'b Content<'a>, usize);

impl<'a, 'b> Display for DisplayContent<'a, 'b> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self.0 {
            Content::Static(s) => write!(f, "{}", s),
            Content::Cmd { last_run, .. } => write!(f, "{}", last_run[self.1].read().unwrap()),
            Content::Persistent { last_run, .. } => {
                write!(f, "{}", last_run[self.1].read().unwrap())
            }
        }
    }
}

#[derive(Debug)]
struct Block<'a> {
    bg: Option<Color<'a>>,
    fg: Option<Color<'a>>,
    un: Option<Color<'a>>,
    font: Option<&'a str>,   // 1-infinity index or '-'
    offset: Option<&'a str>, // u32
    actions: [Option<&'a str>; 5],
    content: Content<'a>,
    interval: Option<(Duration, RwLock<Duration>)>,
    alignment: Alignment,
    raw: bool,
    signal: bool,
    layer: Layer,
}

impl<'a> Block<'a> {
    fn parse(block: &'a str, n_monitor: usize) -> Result<Self, ParseError> {
        let mut block_b = BlockBuilder::default();
        for opt in block.split('\n').skip(1).filter(|s| !s.trim().is_empty()) {
            let (key, value) = opt.split_at(opt.find(':').ok_or((opt, "missing :"))?);
            let value = value[1..]
                .trim()
                .trim_end_matches('\'')
                .trim_start_matches('\'');
            let color = || Color::from_str(value).map_err(|e| (opt, e));
            block_b = match key
                .trim()
                .trim_start_matches('*')
                .trim_start_matches('-')
                .trim()
            {
                "background" | "bg" => block_b.bg(color()?),
                "foreground" | "fg" => block_b.fg(color()?),
                "underline" | "un" => block_b.un(color()?),
                "font" => block_b.font(value).map_err(|e| (opt, e))?,
                "offset" => block_b.offset(value).map_err(|_| (opt, "invalid offset"))?,
                "left-click" => block_b.action(0, value),
                "middle-click" => block_b.action(1, value),
                "right-click" => block_b.action(2, value),
                "scroll-up" => block_b.action(3, value),
                "scroll-down" => block_b.action(4, value),
                "interval" => block_b.interval(Duration::from_secs(
                    value
                        .parse::<u64>()
                        .map_err(|_| (opt, "Invalid duration"))?,
                )),
                "command" | "cmd" => block_b.content_command(value),
                "static" => block_b.content_static(value),
                "persistent" => block_b.content_persistent(value),
                "alignment" | "align" => block_b.alignment(value.parse().map_err(|e| (opt, e))?),
                "signal" => block_b.signal(value.parse().map_err(|_| (opt, "Invalid boolean"))?),
                "raw" => block_b.raw(value.parse().map_err(|_| (opt, "Invalid boolean"))?),
                "multi_monitor" => {
                    block_b.multi_monitor(value.parse().map_err(|_| (opt, "Invalid boolean"))?)
                }
                "layer" => block_b.layer(value.parse().map_err(|e| (opt, e))?),
                s => {
                    eprintln!("Warning: unrecognised option '{}', skipping", s);
                    block_b
                }
            };
        }
        block_b
            .build(n_monitor)
            .map_err(|e| ("BLOCK DEFINITION", e))
    }
}

#[derive(Debug)]
struct DisplayBlock<'a, 'b: 'a>(&'b Block<'a>, usize);

impl<'a, 'b> Display for DisplayBlock<'a, 'b> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        let DisplayBlock(b, mon) = self;
        if b.raw {
            return write!(f, "{}", DisplayContent(&b.content, *mon));
        }
        if let Some(x) = &b.offset {
            f.lemon('O', x)?;
        }
        if let Some(x) = &b.bg {
            f.lemon('B', x)?;
        }
        if let Some(x) = &b.fg {
            f.lemon('F', x)?;
        }
        if let Some(x) = &b.un {
            f.lemon('U', x)?;
            f.write_str("%{+u}")?;
        }
        if let Some(x) = &b.font {
            f.lemon('T', x)?;
        }
        let mut num_cmds = 0;
        for (i, a) in b
            .actions
            .iter()
            .enumerate()
            .filter_map(|(i, o)| o.map(|a| (i, a)))
        {
            write!(f, "%{{A{index}:{cmd}:}}", index = i + 1, cmd = a)?;
            num_cmds += 1;
        }
        write!(f, "{} ", DisplayContent(&b.content, *mon))?;
        (0..num_cmds).try_for_each(|_| f.write_str("%{A}"))?;
        if let Some(_) = &b.offset {
            f.lemon('O', "0")?;
        }
        if let Some(_) = &b.bg {
            f.lemon('B', "-")?;
        }
        if let Some(_) = &b.fg {
            f.lemon('F', "-")?;
        }
        if let Some(_) = &b.un {
            f.lemon('U', "-")?;
            f.write_str("%{-u}")?;
        }
        if let Some(_) = &b.font {
            f.lemon('T', "-")?;
        }
        Ok(())
    }
}

#[derive(Default)]
struct BlockBuilder<'a> {
    bg: Option<Color<'a>>,
    fg: Option<Color<'a>>,
    un: Option<Color<'a>>,
    font: Option<&'a str>,   // 1-infinity index or '-'
    offset: Option<&'a str>, // u32
    actions: [Option<&'a str>; 5],
    content: Option<Content<'a>>,
    interval: Option<Duration>,
    alignment: Option<Alignment>,
    raw: bool,
    signal: bool,
    multi_monitor: bool,
    layer: Layer,
}

impl<'a> BlockBuilder<'a> {
    fn raw(self, r: bool) -> Self {
        Self { raw: r, ..self }
    }

    fn action(mut self, index: usize, action: &'a str) -> Self {
        self.actions[index] = Some(action);
        self
    }

    fn bg(self, c: Color<'a>) -> Self {
        Self {
            bg: Some(c),
            ..self
        }
    }

    fn fg(self, c: Color<'a>) -> Self {
        Self {
            fg: Some(c),
            ..self
        }
    }

    fn un(self, c: Color<'a>) -> Self {
        Self {
            un: Some(c),
            ..self
        }
    }

    fn font(self, font: &'a str) -> Result<Self, &'static str> {
        if font == "-" || font.parse::<u32>().map_err(|_| "Invalid font")? > 0 {
            Ok(Self {
                font: Some(font),
                ..self
            })
        } else {
            Err("Invalid index")
        }
    }

    fn offset(self, o: &'a str) -> Result<Self, <u32 as FromStr>::Err> {
        o.parse::<u32>()?;
        Ok(Self {
            offset: Some(o),
            ..self
        })
    }

    fn content_command(self, c: &'a str) -> Self {
        Self {
            content: Some(Content::Cmd {
                cmd: c,
                last_run: Default::default(),
            }),
            ..self
        }
    }

    fn content_static(self, c: &'a str) -> Self {
        Self {
            content: Some(Content::Static(c)),
            ..self
        }
    }

    fn content_persistent(self, c: &'a str) -> Self {
        Self {
            content: Some(Content::Persistent {
                cmd: c,
                last_run: Default::default(),
            }),
            ..self
        }
    }

    fn interval(self, i: Duration) -> Self {
        Self {
            interval: Some(i),
            ..self
        }
    }

    fn alignment(self, a: Alignment) -> Self {
        Self {
            alignment: Some(a),
            ..self
        }
    }

    fn signal(self, b: bool) -> Self {
        Self { signal: b, ..self }
    }

    fn multi_monitor(self, b: bool) -> Self {
        Self {
            multi_monitor: b,
            ..self
        }
    }

    fn layer(self, layer: Layer) -> Self {
        Self { layer, ..self }
    }

    fn build(self, n_monitor: usize) -> Result<Block<'a>, &'static str> {
        let n_monitor = if self.multi_monitor { n_monitor } else { 1 };
        if let Some(content) = self.content {
            if let Some(alignment) = self.alignment {
                Ok(Block {
                    bg: self.bg,
                    fg: self.fg,
                    un: self.un,
                    font: self.font,
                    offset: self.offset,
                    content: content.replicate_to_mon(n_monitor),
                    interval: self.interval.map(|i| (i, Default::default())),
                    actions: self.actions,
                    alignment,
                    raw: self.raw,
                    signal: self.signal,
                    layer: self.layer,
                })
            } else {
                Err("No alignment defined")
            }
        } else {
            Err("No content defined")
        }
    }
}

trait Lemonbar: Write {
    fn lemon<P, S>(&mut self, prefix: P, s: S) -> fmt::Result
    where
        P: Display,
        S: Display,
    {
        write!(self, "%{{{}{}}}", prefix, s)
    }
}

impl<'a> Lemonbar for fmt::Formatter<'a> {}
impl<'a> Lemonbar for String {}

type Config<'a> = HashMap<Alignment, Vec<Block<'a>>>;

#[derive(Debug, Default)]
struct Args {
    config: Option<String>,
    bars: Vec<String>,
    tray: bool,
}

fn arg_parse() -> io::Result<Args> {
    let mut args = Args::default();
    let mut argv = env::args().skip(1);
    while let Some(arg) = argv.next() {
        match arg.as_str() {
            "-c" | "--config" => {
                args.config = Some(fs::read_to_string(argv.next().ok_or_else(|| {
                    io::Error::new(
                        io::ErrorKind::Other,
                        "Expected argument to geometry parameter",
                    )
                })?)?);
            }
            "-t" | "--tray" => args.tray = true,
            "-b" | "--bar" => {
                args.bars.push(argv.next().ok_or_else(|| {
                    io::Error::new(
                        io::ErrorKind::Other,
                        "Expected argument to geometry parameter",
                    )
                })?);
            }
            _ => (),
        }
    }
    Ok(args)
}

#[derive(Default)]
struct GlobalConfig<'a> {
    base_geometry: Option<&'a str>,
    bars_geometries: Vec<String>,
    bottom: bool,
    font: Option<&'a str>,
    n_clickbles: Option<u32>,
    name: Option<&'a str>,
    underline_width: Option<u32>,
    background: Option<Color<'a>>,
    foreground: Option<Color<'a>>,
    underline: Option<Color<'a>>,
    separator: Option<&'a str>,
    tray: bool,
    n_layers: u16,
}

impl<'a> GlobalConfig<'a> {
    fn to_arg_list(&self, extra_geomtery: Option<&str>) -> Vec<String> {
        let mut vector: Vec<String> = vec![];
        if let Some(g) = &self.base_geometry {
            vector.extend_from_slice(&[
                "-g".into(),
                extra_geomtery
                    .map(|e| merge_geometries(g, e))
                    .unwrap_or_else(|| g.to_string()),
            ]);
        }
        if self.bottom {
            vector.extend_from_slice(&["-b".into()]);
        }
        if let Some(f) = self.font {
            vector.extend_from_slice(&["-f".into(), f.into()]);
        }
        if let Some(n) = self.n_clickbles {
            vector.extend_from_slice(&["-a".into(), n.to_string()]);
        }
        if let Some(n) = self.name {
            vector.extend_from_slice(&["-n".into(), n.to_string()]);
        }
        if let Some(u) = self.underline_width {
            vector.extend_from_slice(&["-u".into(), u.to_string()]);
        }
        if let Some(bg) = &self.background {
            vector.extend_from_slice(&["-B".into(), bg.to_string()]);
        }
        if let Some(fg) = &self.foreground {
            vector.extend_from_slice(&["-F".into(), fg.to_string()]);
        }
        if let Some(un) = &self.underline {
            vector.extend_from_slice(&["-U".into(), un.to_string()]);
        }
        vector.extend_from_slice(&["-d".into()]);
        vector
    }
}

impl<'a> TryFrom<&'a str> for GlobalConfig<'a> {
    type Error = ParseError<'a>;
    fn try_from(globals: &'a str) -> Result<Self, Self::Error> {
        let mut global_config = Self::default();
        for opt in globals.split('\n').filter(|s| !s.trim().is_empty()) {
            let (key, value) = opt.split_at(opt.find(':').ok_or((opt, "missing :"))?);
            let mut value = value[1..].trim();
            if value.contains('\'') {
                value = value
                    .split('\'')
                    .nth(1)
                    .ok_or((opt, "idk man, I tried to get things inside `'`"))?
            }
            println!("{}: {}", key, value);
            let color = || Color::from_str(value).map_err(|e| (opt, e));
            match key
                .trim()
                .trim_start_matches('*')
                .trim_start_matches('-')
                .trim()
            {
                "background" | "bg" | "B" => global_config.background = Some(color()?),
                "foreground" | "fg" | "F" => global_config.foreground = Some(color()?),
                "underline" | "un" | "U" => global_config.underline = Some(color()?),
                "font" | "f" => global_config.font = Some(value),
                "bottom" | "b" => {
                    global_config.bottom = value
                        .trim()
                        .parse()
                        .map_err(|_| (opt, "Not a valid boolean"))?
                }
                "n_clickables" | "a" => {
                    global_config.n_clickbles = Some(
                        value
                            .trim()
                            .parse()
                            .map_err(|_| (opt, "Not a valid number"))?,
                    )
                }
                "underline_width" | "u" => {
                    global_config.underline_width = Some(
                        value
                            .trim()
                            .parse()
                            .map_err(|_| (opt, "Not a valid number"))?,
                    )
                }
                "separator" => global_config.separator = Some(value),
                "geometry" | "g" => global_config.base_geometry = Some(value.into()),
                "name" | "n" => global_config.name = Some(value),
                s => {
                    eprintln!("Warning: unrecognised option '{}', skipping", s);
                }
            }
        }
        Ok(global_config)
    }
}

// TODO:
// Manpage
// - Sdir
// - attribute
//
// Features
// - Signal
fn main() -> io::Result<()> {
    let args = arg_parse()?;
    let input = if let Some(input) = args.config {
        input
    } else {
        if let Some(arg) = env::var_os("XDG_CONFIG") {
            fs::read_to_string(arg)?
        } else if let Ok(home) = env::var("HOME") {
            fs::read_to_string(format!("{}/{}", home, ".config/lemonbar/lemonrc"))?
        } else {
            return Err(io::Error::new(
                io::ErrorKind::NotFound,
                "Couldn't find config file",
            ));
        }
    };
    let input = Box::leak(input.into_boxed_str());
    let (mut global_c, blocks) = match parse(input, args.bars.len()) {
        Ok(b) => b,
        Err((bit, cause)) => {
            eprintln!("Parse error in '{}', {}", bit, cause);
            std::process::exit(1);
        }
    };
    global_c.tray = args.tray;
    global_c.bars_geometries = args.bars;
    println!("Staring blocks");
    for (al, bs) in &blocks {
        println!("{:?}", al);
        for b in bs {
            println!("{:?}", b);
        }
    }
    start_event_loop(global_c, blocks);
    // unsafe { Box::from_raw(input.as_mut_ptr()) };
    Ok(())
}

fn parse(config: &str, monitor: usize) -> Result<(GlobalConfig, Config), ParseError> {
    let mut blocks = HashMap::<Alignment, Vec<Block>>::with_capacity(3);
    let mut blocks_iter = config.split("\n>");
    let mut global_config = blocks_iter
        .next()
        .map(GlobalConfig::try_from)
        .unwrap_or_else(|| Ok(Default::default()))?;
    for block in blocks_iter {
        let b = Block::parse(block, monitor)?;
        if let Layer::L(n) = b.layer {
            global_config.n_layers = global_config.n_layers.max(n);
        }
        blocks.entry(b.alignment).or_default().push(b);
    }
    global_config.n_layers += 1;
    Ok((global_config, blocks))
}

enum Event {
    Update,
    TrayResize(u32),
}

fn spawn_bar<A, S>(args: A) -> ([Child; 2], ChildStdin)
where
    A: IntoIterator<Item = S> + std::fmt::Debug,
    S: AsRef<OsStr>,
{
    let mut lemonbar = Command::new("lemonbar")
        .args(args)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .expect("Couldn't start lemonbar");
    let (le_in, le_out) = (
        lemonbar.stdin.take().expect("Failed to find lemon stdin"),
        lemonbar.stdout.take().expect("Failed to find lemon stdout"),
    );
    let shell = Command::new("sh")
        .stdin(Stdio::from(le_out))
        .spawn()
        .expect("Couldn't start action shell");
    ([lemonbar, shell], le_in)
}

fn start_event_loop(global_config: GlobalConfig, config: Config<'static>) {
    let mut lemon_inputs = if global_config.bars_geometries.is_empty() {
        vec![spawn_bar(&global_config.to_arg_list(None))]
    } else {
        global_config
            .bars_geometries
            .iter()
            .map(|g| global_config.to_arg_list(Some(&g)))
            .map(spawn_bar)
            .collect()
    };
    let (sx, event_loop) = mpsc::channel();
    // Persistent blocks
    let persistent_block_threads = config
        .values()
        .flat_map(|blocks| blocks.iter())
        .filter_map(|b| {
            if let Content::Persistent { cmd, last_run } = &b.content {
                Some((cmd, last_run))
            } else {
                None
            }
        })
        .flat_map(|(cmd, last_run)| last_run.iter().enumerate().map(move |(m, r)| (m, cmd, r)))
        .map(|(m, cmd, r)| {
            let cmd = cmd.to_string();
            let ch = sx.clone();
            let r = Arc::clone(&r);
            thread::spawn(move || persistent_command(cmd, ch, r, m))
        })
        .collect::<Vec<_>>();
    let config = Arc::new(config);
    let layer = Arc::new(RwLock::new(Layer::L(0)));
    let config_ref = Arc::downgrade(&config);
    let layer_ref = Arc::downgrade(&layer);
    let ch = sx.clone();
    // Timer blocks
    let loop_t = thread::spawn(move || {
        while let (Some(c), Some(layer_arc)) = (config_ref.upgrade(), layer_ref.upgrade()) {
            for block in c
                .values()
                .flatten()
                .filter(|b| b.layer == *layer_arc.read().unwrap())
            {
                if let Some((interval, mut b_timer)) = block
                    .interval
                    .as_ref()
                    .map(|(i, l)| (i, l.write().unwrap()))
                {
                    match b_timer.checked_sub(Duration::from_secs(1)) {
                        Some(d) => *b_timer = d,
                        None => {
                            block.content.update();
                            *b_timer = *interval;
                        }
                    }
                }
            }
            ch.send(Event::Update).unwrap();
            thread::sleep(Duration::from_secs(1))
        }
    });
    if global_config.tray {
        trayer(&global_config, sx.clone());
    }
    let config_ref = Arc::downgrade(&config);
    // Signal Capturing thread
    let signal_thread = thread::spawn(move || loop {
        unsafe {
            signal(10, force_update);
        };
        thread::park();
        if let Some(c) = config_ref.upgrade() {
            c.values().flatten().filter(|b| b.signal).for_each(|b| {
                b.content.update();
            });
            sx.send(Event::Update).unwrap();
        } else {
            break;
        }
    });
    unsafe { SIGNAL_THREAD = Some(signal_thread.thread().clone()) };
    let layer_ref = Arc::downgrade(&layer);
    let n_layers = global_config.n_layers;
    let layer_thread = thread::spawn(move || loop {
        if let Some(layer_arc) = layer_ref.upgrade() {
            unsafe {
                signal(11, change_layer);
            };
            thread::park();
            layer_arc.write().unwrap().next(n_layers);
            force_update(10);
        } else {
            break;
        }
    });
    unsafe { LAYER_THREAD = Some(layer_thread.thread().clone()) };
    let mut tray_offset = 0;
    for e in event_loop {
        if let Event::TrayResize(o) = e {
            tray_offset = o;
        }
        for (i, child) in lemon_inputs.iter_mut().enumerate() {
            let line = if i == 0 {
                // trayer goes on first screen
                build_line(&global_config, &config, &layer, tray_offset, i)
            } else {
                build_line(&global_config, &config, &layer, 0, i)
            };
            if let Err(e) = child.1.write_all(line.as_bytes()) {
                eprintln!("Couldn't talk to lemon bar :( {:?}", e);
            }
        }
        let mut i = 0;
        while i < lemon_inputs.len() {
            if lemon_inputs[i]
                .0
                .iter_mut()
                .all(|c| matches!(c.try_wait(), Ok(Some(_))))
            {
                lemon_inputs.remove(i);
            } else {
                i += 1;
            }
        }
        if lemon_inputs.is_empty() {
            break;
        }
    }
    drop(config);
    eprintln!("Waiting on layer thread");
    layer_thread.thread().unpark();
    layer_thread.join().unwrap();
    eprintln!("Waiting on signal thread");
    signal_thread.thread().unpark();
    signal_thread.join().unwrap();
    eprintln!("Waiting on loop_t thread");
    loop_t.join().unwrap();
    eprintln!("Waiting on persistent block threads");
    persistent_block_threads
        .into_iter()
        .for_each(|t| t.join().unwrap());
}

fn build_line(
    global_config: &GlobalConfig,
    config: &Config,
    layer: &RwLock<Layer>,
    tray_offset: u32,
    monitor: usize,
) -> String {
    let mut line = String::new();
    let add_blocks = |blocks: &[Block], l: &mut String| {
        blocks
            .iter()
            .filter(|b| !b.content.is_empty(monitor))
            .filter(|b| b.layer == *layer.read().unwrap())
            .map(|b| DisplayBlock(b, monitor))
            .zip(std::iter::successors(Some(Some("")), |_| {
                Some(global_config.separator)
            }))
            .for_each(|(b, s)| {
                s.map(|s| l.push_str(s));
                write!(l, "{}", b).unwrap();
            })
    };
    if let Some(blocks) = config.get(&Alignment::Left) {
        line.push_str("%{l}");
        add_blocks(blocks, &mut line);
    }
    if let Some(blocks) = config.get(&Alignment::Middle) {
        line.push_str("%{c}");
        add_blocks(blocks, &mut line);
    }
    if let Some(blocks) = config.get(&Alignment::Right) {
        line.push_str("%{r}");
        add_blocks(blocks, &mut line);
    }
    line.lemon('O', tray_offset).unwrap();
    line + "\n"
}

static mut SIGNAL_THREAD: Option<Thread> = None;
static mut LAYER_THREAD: Option<Thread> = None;

extern "C" fn force_update(_: i32) {
    unsafe {
        SIGNAL_THREAD.as_ref().map(|s| s.unpark());
    }
}

extern "C" fn change_layer(_: i32) {
    unsafe {
        LAYER_THREAD.as_ref().map(|s| s.unpark());
    }
}

fn persistent_command(
    cmd: String,
    ch: mpsc::Sender<Event>,
    last_run: Arc<RwLock<String>>,
    monitor: usize,
) {
    let mut persistent_cmd = Command::new("sh")
        .args(&["-c", &cmd])
        .stdout(Stdio::piped())
        .env("MONITOR", &monitor.to_string())
        .spawn()
        .expect("Couldn't start persistent cmd");
    let _ = BufReader::new(
        persistent_cmd
            .stdout
            .take()
            .expect("Couldn't get persistent cmd stdout"),
    )
    .lines()
    .map(Result::unwrap)
    .try_for_each(|l| {
        *last_run.write().unwrap() = l;
        ch.send(Event::Update)
    });
    let _ = persistent_cmd.kill();
    let _ = persistent_cmd.wait();
}

fn trayer(global_config: &GlobalConfig, ch: mpsc::Sender<Event>) {
    let mut trayer = Command::new("trayer");
    trayer.args(&[
        "--edge",
        "top",
        "--align",
        "right",
        "--widthtype",
        "request",
        "--height",
        global_config
            .base_geometry
            .as_ref()
            .and_then(|x| x.split("x").nth(1))
            .and_then(|x| x.split("+").next())
            .unwrap_or("18"),
        "--tint",
        "#FFFFFF",
        "--transparent",
        "true",
        "--expand",
        "true",
        "--SetDockType",
        "true",
        "--alpha",
        "0",
    ]);
    thread::spawn(move || {
        Command::new("killall")
            .arg("trayer")
            .spawn()
            .unwrap()
            .wait()
            .unwrap();
        let mut trayer = match trayer.spawn() {
            Err(e) => return eprintln!("Couldn't start trayer: {}", e),
            Ok(t) => t,
        };
        thread::sleep(Duration::from_millis(500));
        let mut xprop = Command::new("xprop")
            .args(&[
                "-name",
                "panel",
                "-f",
                "WM_SIZE_HINTS",
                "32i",
                " $5\n",
                "-spy",
                "WM_NORMAL_HINTS",
            ])
            .stdout(Stdio::piped())
            .spawn()
            .expect("Couldn't spy tray size");
        let xprop_output = xprop
            .stdout
            .take()
            .expect("Couldn't read tray size spy output");
        let _ = BufReader::new(xprop_output)
            .lines()
            .filter_map(Result::ok)
            .try_for_each(|l| {
                l.split(" ")
                    .nth(1)
                    .and_then(|x| {
                        x.parse()
                            .map_err(|_| eprintln!("Failed to parse size: '{}' from '{}'", x, l))
                            .ok()
                    })
                    .and_then(|o: u32| ch.send(Event::TrayResize(o + 5)).ok())
            });
        let _ = xprop.kill();
        let _ = trayer.kill();
        let _ = xprop.wait();
        let _ = trayer.wait();
    });
}

fn merge_geometries(geo1: &str, geo2: &str) -> String {
    if geo1.is_empty() {
        return geo2.into();
    }
    if geo2.is_empty() {
        return geo1.into();
    }
    let parse = |geo: &str| {
        let (geow, geo) = geo.split_at(geo.find('x').unwrap_or(0));
        let geo = geo.get(1..).unwrap_or("");
        let (geoh, geo) = geo.split_at(geo.find('+').unwrap_or(geo.len()));
        let (geox, geoy) = geo
            .get(1..)
            .and_then(|s| s.find('+').map(|i| s.split_at(i)))
            .unwrap_or(("", ""));
        (
            geow.parse::<i32>().unwrap_or(0),
            geoh.parse::<i32>().unwrap_or(0),
            geox.parse::<i32>().unwrap_or(0),
            geoy.parse::<i32>().unwrap_or(0),
        )
    };

    let (geo1w, geo1h, geo1x, geo1y) = parse(geo1);
    let (geo2w, geo2h, geo2x, geo2y) = parse(geo2);

    format!(
        "{}x{}+{}+{}",
        geo1w + geo2w,
        geo1h + geo2h,
        geo1x + geo2x,
        geo1y + geo2y
    )
}
