#!/bin/sh

if [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v git)" ]; then
  echo 'Error: curl or git is not installed.'
  exit
fi

# create directory
if [ -d $HOME/editor ]; then
    editorpath="$HOME/editor"
elif [ -d $HOME/Editor ]; then
    editorpath="$HOME/Editor"
else
    editorpath="$HOME/editor"
    mkdir -p $editorpath
    mkdir -p $editorpath/vim
fi

echo "editor path: $editorpath"

# backup old vimrc files
if [ -f $HOME/.vimrc ]; then
    mv $HOME/.vimrc $editorpath/vimrc.old
    echo "back up old vimrc file to $editorpath/vimrc.old"
fi
if [ -d $HOME/.vim ]; then
    mv $HOME/.vim $editorpath/vim.old
    echo "back up old vim directory to $editorpath/vim.old"
fi

# overwite with new vimrc file
cp ./vimrc $editorpath/vimrc
ln -s $editorpath/vimrc $HOME/.vimrc
ln -s $editorpath/vim $HOME/.vim

# install plugin Vundle if not installed
if [ ! -d $editorpath/vim/bundle ]; then
    mkdir -p $editorpath/vim/bundle
fi
if [ ! -d $editorpath/vim/bundle/Vundle.vim ]; then
    mkdir -p $editorpath/vim/bundle/Vundle.vim
    git clone https://github.com/VundleVim/Vundle.vim.git $editorpath/vim/bundle/Vundle.vim
fi

# install flake8 for syntax checking
echo "Please install flake8 for syntax checking"
# pip install flake8

if [ -d fasdfsa ]; then


