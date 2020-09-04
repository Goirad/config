#!/bin/bash

#git
sudo apt install git -qy
git config --global user.email "goiradio1@gmail.com"
git config --global user.name "Dario Gonzalez"
git config --global push.default simple
git config --global core.editor nvim

sudo apt install -qy curl htop feh \
                     pavucontrol redshift \
                     lm-sensors firefox xinit

#rust
if ! rustup --version &>/dev/null ; then
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
    rustup component add rust-analysis rust-src
fi
source ~/.cargo/env

#utilities
cargo install ripgrep
cargo install fd-find
mkdir ~/oss
pushd ~/oss
git clone https://github.com/rust-analyzer/rust-analyzer.git
cd rust-analyzer
cargo xtask install --server
popd

#neovim
sudo apt-get install neovim -qy
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#fonts
sudo apt install -qy fonts-font-awesome \
                     fonts-powerline \
                     fonts-firacode

#i3status-rust
sudo apt install libdbus-1-dev -qy
cargo install --git https://github.com/greshake/i3status-rust

#get configs
git clone https://github.com/goirad/config
rm -rf ~/.config/i3 ~/.config/nvim ~/.config/alacritty \
       ~/.bashrc ~/.config/redshift.conf ~/.config/scripts

#link them to where they are expected
#might be a better idea to link individual files instead of folders?
ln -s ~/config/i3 ~/.config/
ln -s ~/config/nvim ~/.config/
ln -s ~/config/alacritty ~/.config/
ln -s ~/config/.bashrc ~/
ln -s ~/config/redshift.conf ~/.config/
ln -s ~/config/scripts ~/.config

#install neovim plugins then exit
#also installs fzf
nvim +'PlugInstall --sync' +qa

#alacritty
#first some build deps
sudo apt install -qy cmake pkg-config libfreetype6-dev \
                     libfontconfig1-dev libxcb-xfixes0-dev \
                     python3
cargo install --git https://github.com/alacritty/alacritty
sudo update-alternatives --install /usr/bin/x-terminal-emulator \
    x-terminal-emulator ~/.cargo/bin/alacritty 50

#i3gaps
sudo add-apt-repository ppa:kgilmer/speed-ricer
sudo apt-get update
# fix nautilus bug for i3
gsettings set org.gnome.desktop.background show-desktop-icons false


