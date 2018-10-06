#!/bin/sh

if [ -d ~/editor ]; then
    editorpath="~/editor"
elif [ -d ~/Editor ]; then
    editorpath="~/Editor"
else
    editorpath="~/editor"
    mkdir -p $editorpath
    mkdir -p $editorpath/vim
fi
echo "editor path: $editorpath"

# backup old vimrc files
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc $editorpath/vimrc.old
    echo "back up old vimrc file to $editorpath/vimrc.old"
fi
if [ -d ~/.vim ]; then
    mv ~/.vim $editorpath/vim.old
    echo "back up old vim directory to $editorpath/vim.old"
fi

# overwite with new vimrc file
cp ./vimrc $editorpath/vimrc
ln -s $editorpath/vimrc ~/.vimrc
ln -s $editorpath/vim ~/.vim

