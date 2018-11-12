#!/bin/bash

if [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v git)" ]; then
    echo 'Error: curl or git is not installed.'
    exit
fi

currentpath=`pwd`
echo "Current path: $currentpath"

# backup old vimrc files
if [ -f $HOME/.vimrc ] && [ ! `readlink $HOME/.vimrc` = $currentpath/vimrc ]; then
    mv $HOME/.vimrc $currentpath/vimrc.old
    echo "Back up old vimrc file to $currentpath/vimrc.old"
fi
if [ -d $HOME/.vim ] && [ ! `readlink $HOME/.vim` = $currentpath/vimdir ]; then
    mv $HOME/.vim $currentpath/vim.old
    echo "Back up old vim directory to $currentpath/vim.old"
fi

# link to new file
if [ ! -d $currentpath/vimdir ]; then
    mkdir -p $currentpath/vimdir
fi
if [ `uname` = 'Darwin' ]; then
  ln -sfh $currentpath/vimdir $HOME/.vim
  ln -sfh $currentpath/vimrc  $HOME/.vimrc
else
  ln -sfT $currentpath/vimdir $HOME/.vim
  ln -sfT $currentpath/vimrc  $HOME/.vimrc
fi
echo "Link $HOME/.vim   to $currentpath/vimdir"
echo "Link $HOME/.vimrc to $currentpath/vimrc"

# update neovim config if neovim it installed
if [ -x "$(command -v nvim)" ]; then
    read -p "Update neovim config? (y/n, default: y)" yn
    if [ -z "$yn" ]; then
        update_nvim=yes
    else
        case $yn in
            [Yy]* ) echo "aha?"; update_nvim=yes;;
        esac
    fi
    if [ "$update_nvim" = "yes" ]; then
        if [ ! -d $HOME/.config/nvim ]; then
            mkdir -p $HOME/.config/nvim
        fi
        if [ -f $HOME/.config/nvim/init.vim ]; then
            mv $HOME/.config/nvim/init.vim ./init.vim.old
            echo "Backup old $HOME/.config/nvim/init.vim to ./init.vim.old"
        fi
        ln -s $currentpath/vimrc $HOME/.config/nvim/init.vim
        echo "Link $HOME/.config/nvim/init.vim to $currentpath/vimrc"
    fi
fi

# for Vim install plugin Vundle if not installed
vundle_path=$currentpath/vimdir/bundle/Vundle.vim
if [ ! -d $vundle_path ]; then
    mkdir -p $vundle_path
    git clone https://github.com/VundleVim/Vundle.vim.git $vundle_path
    echo "For Vim, installed Vundle.vim to $vundle_path"
fi

# for Neovim, install vim-plug if not installed
if [ -x "$(command -v nvim)" ]; then
    vim_plug_path=$HOME/.local/share/nvim/site/autoload/plug.vim
    if [ ! -f $vim_plug_path ]; then
        curl -fLo $vim_plug_path --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo "For neovim, installed vim-plug to $vim_plug_path"
    fi
fi

# install suggestions
# echo "Suggest to install flake8 for syntax checking:"
# echo "--> pip install flake8"
# echo "Suggest to install exuberant-ctags:"
# echo "--> sudo apt-get install exuberant-ctags"

