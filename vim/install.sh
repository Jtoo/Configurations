#!/bin/sh

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
ln -sfT $currentpath/vimdir $HOME/.vim
ln -sfT $currentpath/vimrc  $HOME/.vimrc
echo "Link $HOME/.vim   to $currentpath/vimdir"
echo "Link $HOME/.vimrc to $currentpath/vimrc"

# update neovim config
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

# for Vim install plugin Vundle if not installed
if [ ! -d $currentpath/vimdir/bundle/Vundle.vim ]; then
    mkdir -p $currentpath/vimdir/bundle/Vundle.vim
    git clone https://github.com/VundleVim/Vundle.vim.git $currentpath/vim/bundle/Vundle.vim
    echo "For Vim, installed Vundle.vim to $currentpath/vimdir/bundle/Vundle.vim"
fi
# for Neovim, install vim-plug if not installed
if [ -x "$(command -v nvim)" ]; then
    if [ ! -f $HOME/.local/share/nvim/site/autoload/plug.vim ]; then
        curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        echo "For neovim, installed vim-plug to $HOME/.local/share/nvim/site/autoload/plug.vim"
    fi
fi

# install suggestions
# echo "Suggest to install flake8 for syntax checking:"
# echo "--> pip install flake8"
# echo "Suggest to install exuberant-ctags:"
# echo "--> sudo apt-get install exuberant-ctags"

