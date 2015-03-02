#!/bin/sh
# Configure Go Development environment for the current user on a fresh Ubuntu 14.04 amd64 desktop
GITUSER="paulswanson"
GOVERSION="1.4.2"

cd ~/

echo Preparing to install development tools ...
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install vim curl git
sudo mkdir /usr/local/go
sudo chown $USER:$USER /usr/local/go
curl -O https://storage.googleapis.com/golang/go$GOVERSION.linux-amd64.tar.gz
tar -C /usr/local/ -xzf go$GOVERSION.linux-amd64.tar.gz

echo Configuring local Go development environment ...
mkdir -p ~/go/src ~/go/pkg ~/go/bin ~/go/src/github.com/$GITUSER
EGOBIN="export GOBIN=/usr/local/go/bin"
EGOPATH="export GOPATH=\$HOME/go"
EGOPAUL="export GOPAUL=\$GOPATH/src/github.com/$GITUSER"
EPATH="export PATH=\$PATH:\$GOPATH/bin:\$GOBIN"
echo $EGOBIN >> ~/.profile
echo $EGOPATH >> ~/.profile
echo $EGOPAUL >> ~/.profile
echo $EPATH >> ~/.profile
echo godoc -http=:6060 \& >> ~/.profile
eval $EGOBIN
eval $EGOPATH
eval $EGOPAUL
eval $EPATH

echo Installing vim-pathogen ...
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

echo Installing vim-go ...
git clone https://github.com/fatih/vim-go.git ~/.vim/bundle/vim-go

echo Installing vim-colors-solarized ...
git clone git://github.com/altercation/vim-colors-solarized.git ~/.vim/bundle/vim-colors-solarized

echo Configuring vim ...
VIMRCCFG=$(cat <<EOF
set nocompatible
set t_Co=16
execute pathogen#infect()
filetype indent plugin on
syntax enable
set background=dark
colorscheme solarized
call togglebg#map("<F5>")
set number
set mouse=a
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_fmt_command = "goimports"
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
EOF
)
echo "${VIMRCCFG}" > ~/.vimrc

echo Installing gnome-terminal-colors-solarized ...
git clone https://github.com/sigurdga/gnome-terminal-colors-solarized /tmp/gnome-terminal-colors-solarized
/tmp/gnome-terminal-colors-solarized/install.sh

echo Installing dircolors-solarized ...
git clone https://github.com/seebi/dircolors-solarized.git /tmp/dircolors-solarized
cp /tmp/dircolors-solarized/dircolors.ansi-dark ~/.dir_colors
echo eval \$\(dircolors ~/.dir_colors\) >> ~/.bashrc

echo Install extra Go binaries for vim-go ...
vim +GoInstallBinaries +qall InstallingGoBinaries-for-Vim-Go

echo Done! Reboot for changes to take effect.
