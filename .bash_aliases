#!/bin/bash

export PATH=./:~/bin:~/AMI/tools:$PATH


export EDITOR=emacs

export PS1='\h:\w`if [ $UID -eq 0 ]; then echo "# "; else echo "$ "; fi`'
if [ -n "$INSIDE_EMACS" ]; then
     unset PROMPT_COMMAND 
fi

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias cp='cp -d'
alias ll='ls -l'
alias ja='ssh -X -l karafiat kazi.fit.vutbr.cz'

function em(){
if [ -z $DISPLAY ]; then 
   emacs $1 
else
 emacs $1 &
fi
}


alias matlab='TERM=vt102 matlab -nojvm -nosplash'
#function gzcat(){
#gunzip -c $* 
#}

function mwhich(){
more `which $1`
}

function emwhich(){
em `which $1`
}

