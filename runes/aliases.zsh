allgrep(){
    grep -Hne $1 $(find . | grep -v 'git' | grep -v 'node_modules') 2>/dev/null
}

allsed(){
    if [[ "$#" < 2 ]];
    then
        echo "Usage: allsed <find> <replace>"
    else
        for i in $(find . | grep -v '.git' 2>/dev/null);
        do
            sed -i '' -e "s/$1/$2/g" $i 2> /dev/null
        done
    fi
}

benchmark(){
    for i in {1..5};
    do
        echo -e "\033[34mRun #$i: Starting\033[0m"
        time ./$1 #&> /dev/null
        if (( $? ));
        then
            echo -e "\033[31mRun #$i: Failed\033[0m"
        else
            echo -e "\033[32mRun #$i: Done\033[0m"
        fi

        if [[ $i == 5 ]];
        then
            break
        fi

        for t in {30..0};
        do
            echo -en $t
            sleep 1s
            echo -en "\b\b"
        done;
    done;
}

make(){
    if [ -e Makefile ] || [ -e makefile ]
    then
        bash -c "make $@"
    else
        for i in *.c;
        do
            file=$(echo $i | sed -e "s/\.c//g")
            bash -c "make $file"
        done
    fi
}
json(){
    if [[ $# < 1 ]];
    then
        echo "usage: curl [link]"
    else
        curl $1 | python -m json.tool | less
    fi
}

check_ununtu(){
    sudo mount /dev/sdb1 /mnt/mnt1
    ls -l /mnt/mnt1
    sudo umount /mnt/mnt1
    ls -l /mnt/mnt1
}

ex(){
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

pdf(){
    if [[ $# < 1 ]]
    then
        echo "Usage: pdf file.pdf"
    else
        evince $1 &
        disown
        exit
    fi
}

allgst (){
    for dir in $(find . -mindepth 1 -maxdepth 1 -type d)
    do
        cd $dir
        git status
        echo -n 'Git pull? [y/n] '
        read a
        if [[ "$a" == "y" ]]
        then
            git pull --rebase
        fi
        cd ..
    done
}

alias zshrc="vim ~/.oh-my-zsh/custom/aliases.zsh"
alias open="xdg-open"
alias clip="xclip -sel clip"
alias vimrc="vim ~/.config/nvim/init.vim"
alias py="python3"
alias c="clear"
alias sepuku="toilet -f smblock -F metal:border Shuting Down... && sleep 1; shutdown +0 &> /dev/null"
alias rmdir="rm -rfI"
alias pyenv="source env/bin/activate"
alias makeclean="find . -maxdepth 1 -type f -executable -delete"
alias makeinstall='for i in *.c; make $(echo $i | sed -e "s/\.c//g")'
alias :q="exit"
alias countLines="echo 'Number of lines '\$(echo \$(for i in \$(find . | grep -v '\.git/'); do wc -l \$i 2> /dev/null | awk '{print \$1}'; done) | sed 's/\\ /+/g' | bc)"
alias vim="nvim"
alias gps='git push --set-upstream origin $(git symbolic-ref --short HEAD)'
alias dex="~/gitProjects/unix_dex/target/debug/unix_dex"
alias bc="bc -l"
alias ghci="stack ghci"
alias reload="source ~/.zshrc"
alias cl="clear; ls -la"
alias pls='sudo $(history -1 | cut -d" " -f6-)'
alias vim.='vim .'
alias mnol="cd gitProjects/MNOL/"
alias idea="idea &; disown; exit"
