# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/mendes/.oh-my-zsh
  export PATH=~/.bin:$PATH
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="gallois"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd/mm/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  catimg
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

export RTV_EDITOR='vim'
export WWW_HOME='duckduckgo.com/lite'
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias open="xdg-open"
alias clip="xclip -sel clip"
alias vimrc="vim ~/.vimrc"
alias py="python3"
alias clean="clear"
alias c="clear"
alias space="du -sh"
alias untar="tar -xzf"
alias intellij="/opt/idea/bin/idea.sh & 2> /dev/null"
alias changeW="/home/mendes/gitProjects/spells/changeMeWall.sh"
alias changeWc="/home/mendes/gitProjects/spells/changeMeWallCicle.sh &"
alias sepuku="shutdown +0"
alias rmdir="rm -rfI"
alias prolog="/usr/local/sicstus4.3.0/bin/sicstus-4.3.0"
alias vgup="cd ~/Homestead && vagrant up"
alias vghalt="cd ~/Homestead && vagrant halt"
alias jump="/home/mendes/Small-interesting-scripts/better-cd/bcd"
alias fucking="sudo"
alias pyenv="source env/bin/activate"
alias makeclean="find . -maxdepth 1 -type f -executable -delete"
alias appinstall="sudo apt-get install"
alias makeinstall='for i in *.c; make $(echo $i | sed -e "s/\.c//g")'
alias :q="exit"
alias xyzzy="sudo !!"
alias countLines="echo 'Number of lines '\$(echo \$(for i in \$(find . | grep -v .git); do wc -l \$i 2> /dev/null | awk '{print \$1}'; done) | sed 's/\\ /+/g' | bc)"
alias latexBuilder="terminator -l latexBuilder 2> /dev/null &"
alias autoLatexBuilder="~/gitProjects/spells/autoUpdateTex.sh"
alias firefox="firefox &"
alias fire="firefox &"
#startup things
fortune | cowthink $(echo " \n-b\n-d\n-g\n-p\n-s\n-t\n-w\n-y" | shuf -n1)
