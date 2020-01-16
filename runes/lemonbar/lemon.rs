use std::{
    borrow::Cow,
    collections::HashMap,
    env,
    fmt::{self, Display, Write},
    fs,
    io::{self, BufRead, BufReader, Write as _},
    process::{Command, Stdio},
    str::{self, FromStr},
    sync::{mpsc, Arc, RwLock},
    thread::{self, Thread},
    time::Duration,
};

extern "C" {
    fn signal(sig: i32, handler: extern "C" fn(i32) -> i32) -> extern "C" fn(i32) -> i32;
}

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

#[derive(Copy, Clone, PartialEq, Eq, Hash)]
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

enum Content<'a> {
    Static(&'a str),
    Cmd {
        cmd: &'a str,
        last_run: RwLock<String>,
    },
    Persistent {
        cmd: &'a str,
        last_run: Arc<RwLock<String>>,
    },
}

impl<'a> Display for Content<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            Self::Static(s) => write!(f, "{}", s),
            Self::Cmd { last_run, .. } => write!(f, "{}", last_run.read().unwrap()),
            Self::Persistent { last_run, .. } => write!(f, "{}", last_run.read().unwrap()),
        }
    }
}

impl<'a> Content<'a> {
    fn update(&self) {
        if let Self::Cmd { cmd, last_run } = self {
            match Command::new("sh")
                .args(&["-c", cmd])
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
                Ok(o) => *last_run.write().unwrap() = o,
                Err(e) => *last_run.write().unwrap() = e,
            }
        }
    }

    fn is_empty(&self) -> bool {
        match self {
            Self::Static(s) => s.is_empty(),
            Self::Cmd { last_run, .. } => last_run.read().unwrap().is_empty(),
            Self::Persistent { last_run, .. } => last_run.read().unwrap().is_empty(),
        }
    }
}

struct Block<'a> {
    bg: Option<Color<'a>>,
    fg: Option<Color<'a>>,
    un: Option<Color<'a>>,
    font: Option<&'a str>,   // 1-infinity index or '-'
    offset: Option<&'a str>, // u32
    actions: [Option<&'a str>; 5],
    content: Content<'a>,
    interval: Duration,
    timer: RwLock<Duration>,
    alignment: Alignment,
    raw: bool,
    signal: bool,
}

impl<'a> Display for Block<'a> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if self.raw {
            return write!(f, "{}", self.content);
        }
        if let Some(x) = &self.offset {
            f.lemon('O', x)?;
        }
        if let Some(x) = &self.bg {
            f.lemon('B', x)?;
        }
        if let Some(x) = &self.fg {
            f.lemon('F', x)?;
        }
        if let Some(x) = &self.un {
            f.lemon('U', x)?;
            f.write_str("%{+u}")?;
        }
        if let Some(x) = &self.font {
            f.lemon('T', x)?;
        }
        let mut num_cmds = 0;
        for (i, a) in self
            .actions
            .iter()
            .enumerate()
            .filter_map(|(i, o)| o.map(|a| (i, a)))
        {
            write!(f, "%{{A{index}:{cmd}:}}", index = i + 1, cmd = a)?;
            num_cmds += 1;
        }
        write!(f, "{}", self.content)?;
        (0..num_cmds).try_for_each(|_| f.write_str("%{A}"))?;
        if let Some(_) = &self.offset {
            f.lemon('O', "0")?;
        }
        if let Some(_) = &self.bg {
            f.lemon('B', "-")?;
        }
        if let Some(_) = &self.fg {
            f.lemon('F', "-")?;
        }
        if let Some(_) = &self.un {
            f.lemon('U', "-")?;
            f.write_str("%{-u}")?;
        }
        if let Some(_) = &self.font {
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

    fn build(self) -> Result<Block<'a>, &'static str> {
        if self.content.is_none() {
            Err("No content defined")
        } else if self.alignment.is_none() {
            Err("No alignment defined")
        } else {
            Ok(Block {
                bg: self.bg,
                fg: self.fg,
                un: self.un,
                font: self.font,
                offset: self.offset,
                content: self.content.unwrap(),
                interval: self.interval.unwrap_or_else(|| Duration::from_secs(10)),
                actions: self.actions,
                alignment: self.alignment.unwrap(),
                timer: Default::default(),
                raw: self.raw,
                signal: self.signal,
            })
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

#[derive(Default)]
struct Args {
    config: Option<String>,
    geometry: Option<String>,
    tray: bool,
}

fn arg_parse() -> io::Result<Args> {
    let mut args = Args::default();
    let mut argv = env::args().skip(1);
    while let Some(arg) = argv.next() {
        match arg.as_str() {
            "-c" | "--config" => {
                args.config = Some(fs::read_to_string(
                    argv.next().expect("Expected argument to config parameter"),
                )?);
            }
            "-g" | "--geometry" => {
                args.geometry = Some(
                    argv.next()
                        .expect("Expected argument to geometry parameter"),
                );
            }
            "-t" | "--tray" => args.tray = true,
            _ => (),
        }
    }
    Ok(args)
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
    let input: &'static mut str = Box::leak(input.into_boxed_str());
    let (mut global_c, blocks) = match parse(input) {
        Ok(b) => b,
        Err((bit, cause)) => {
            eprintln!("Parse error in '{}', {}", bit, cause);
            std::process::exit(1);
        }
    };
    if let Some(geo) = args.geometry {
        match global_c.geometry {
            Some(g) => global_c.geometry = Some(merge_geometries(&g, &geo).into()),
            None => global_c.geometry = Some(geo.into()),
        }
    }
    global_c.tray = args.tray;
    start_event_loop(global_c, blocks);
    // unsafe { Box::from_raw(input.as_mut_ptr()) };
    Ok(())
}

#[derive(Default)]
struct GlobalConfig<'a> {
    geometry: Option<Cow<'a, str>>,
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
}

impl<'a> GlobalConfig<'a> {
    fn to_arg_list(&self) -> Vec<String> {
        let mut vector: Vec<String> = vec![];
        if let Some(g) = &self.geometry {
            vector.extend_from_slice(&["-g".into(), g.to_string()]);
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

fn parse(config: &str) -> Result<(GlobalConfig, Config), (&str, &str)> {
    let mut blocks = HashMap::<Alignment, Vec<Block>>::with_capacity(3);
    let mut blocks_iter = config.split("\n>");
    let mut global_config = GlobalConfig::default();
    if let Some(globals) = blocks_iter.next() {
        for opt in globals.split('\n').filter(|s| !s.trim().is_empty()) {
            let (key, value) = opt.split_at(opt.find(':').ok_or((opt, "missing :"))?);
            let value = value[1..].trim_matches('\'');
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
                "geometry" | "g" => global_config.geometry = Some(value.into()),
                "name" | "n" => global_config.name = Some(value),
                s => {
                    eprintln!("Warning: unrecognised option '{}', skipping", s);
                }
            }
        }
    }
    for block in blocks_iter {
        let mut block_b = BlockBuilder::default();
        for opt in block.split('\n').skip(1).filter(|s| !s.trim().is_empty()) {
            let (key, value) = opt.split_at(opt.find(':').ok_or((opt, "missing :"))?);
            let value = value[1..].trim().trim_end_matches('\'');
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
                s => {
                    eprintln!("Warning: unrecognised option '{}', skipping", s);
                    block_b
                }
            };
        }
        let b = block_b.build().map_err(|e| ("BLOCK DEFINITION", e))?;
        blocks.entry(b.alignment).or_default().push(b)
    }
    Ok((global_config, blocks))
}

fn build_line(global_config: &GlobalConfig, config: &Config, tray_offset: u32) -> String {
    let mut line = String::new();
    let add_blocks = |blocks: &[Block], l: &mut String| {
        blocks
            .iter()
            .filter(|b| !b.content.is_empty())
            .map(ToString::to_string)
            .zip(std::iter::successors(Some(Some("")), |_| {
                Some(global_config.separator)
            }))
            .for_each(|(b, s)| {
                s.map(|s| l.push_str(s));
                l.push_str(&b)
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

enum Event {
    Update,
    TrayResize(u32),
}

fn start_event_loop(global_config: GlobalConfig, config: Config<'static>) {
    let lemonbar = Command::new("lemonbar")
        .args(global_config.to_arg_list())
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .spawn()
        .expect("Couldn't start lemonbar");
    let (mut le_in, le_out) = (
        lemonbar.stdin.expect("Failed to find lemon stdin"),
        lemonbar.stdout.expect("Failed to find lemon stdout"),
    );
    Command::new("sh")
        .stdin(Stdio::from(le_out))
        .spawn()
        .expect("Couldn't start action shell");
    let (sx, event_loop) = mpsc::channel();
    for blocks in config.values() {
        for b in blocks {
            if let Content::Persistent { cmd, last_run } = &b.content {
                let cmd = cmd.to_string();
                let ch = sx.clone();
                let last_run = Arc::clone(&last_run);
                thread::spawn(|| persistent_command(cmd, ch, last_run));
            }
        }
    }
    let config = Arc::new(config);
    let config_ref = Arc::downgrade(&config);
    let ch = sx.clone();
    let loop_t = thread::spawn(move || {
        while let Some(c) = config_ref.upgrade() {
            for block in c.values().flatten() {
                let mut b_timer = block.timer.write().unwrap();
                match b_timer.checked_sub(Duration::from_secs(1)) {
                    Some(d) => *b_timer = d,
                    None => {
                        block.content.update();
                        *b_timer = block.interval;
                    }
                }
            }
            ch.send(Event::Update).unwrap();
            thread::sleep(Duration::from_secs(1))
        }
    });
    let config_ref = Arc::downgrade(&config);
    if global_config.tray {
        trayer(&global_config, sx.clone());
    }
    let signal_thread = thread::spawn(move || loop {
        unsafe {
            signal(10, handle);
        };
        thread::park();
        if let Some(c) = config_ref.upgrade() {
            c.values()
                .flatten()
                .filter(|b| b.signal)
                .for_each(|b| b.content.update());
            sx.send(Event::Update).unwrap();
        }
    });
    unsafe { SIGNAL_THREAD = Some(signal_thread.thread().clone()) };
    let mut tray_offset = 0;
    for e in event_loop {
        if let Event::TrayResize(o) = e {
            tray_offset = o;
        }
        let line = build_line(&global_config, &config, tray_offset);
        le_in
            .write_all(line.as_bytes())
            .expect("Couldn't talk to lemon bar :(");
    }
    drop(config);
    loop_t.join().unwrap();
    signal_thread.join().unwrap();
}

static mut SIGNAL_THREAD: Option<Thread> = None;

extern "C" fn handle(x: i32) -> i32 {
    unsafe {
        SIGNAL_THREAD.as_ref().map(|s| s.unpark());
    }
    x
}

fn persistent_command(cmd: String, ch: mpsc::Sender<Event>, last_run: Arc<RwLock<String>>) {
    BufReader::new(
        Command::new("sh")
            .args(&["-c", &cmd])
            .stdout(Stdio::piped())
            .spawn()
            .expect("Couldn't start persistent cmd")
            .stdout
            .expect("Couldn't get persistent cmd stdout"),
    )
    .lines()
    .map(Result::unwrap)
    .for_each(|l| {
        *last_run.write().unwrap() = l;
        ch.send(Event::Update).unwrap();
    })
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
            .geometry
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
        trayer.spawn().expect("Couldn't start trayer");
        thread::sleep(Duration::from_millis(500));
        let o = Command::new("xprop")
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
            .expect("Couldn't spy tray size")
            .stdout
            .expect("Couldn't read tray size spy output");
        BufReader::new(o)
            .lines()
            .filter_map(Result::ok)
            .for_each(|l| {
                l.split(" ")
                    .nth(1)
                    .and_then(|x| {
                        x.parse()
                            .map_err(|_| eprintln!("Failed to parse size: '{}' from '{}'", x, l))
                            .ok()
                    })
                    .and_then(|o: u32| ch.send(Event::TrayResize(o + 5)).ok());
            })
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
