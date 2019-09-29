#!/bin/bash

#git
sudo apt install git -qy
git config --global user.email "goiradio1@gmail.com"
git config --global user.name "Dario Gonzalez"
git config --global push.default simple

sudo apt install curl -qy
sudo apt install htop -qy
sudo apt install feh -qy
sudo apt install pavucontrol -qy
sudo apt install redshift -qy

#
#emacs
sudo add-apt-repository ppa:kelleyk/emacs -y
sudo apt-get update
sudo apt install emacs26-nox -qy

#rust
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
source .cargo/env

#utilities
rustup component add rls rust-analysis rust-src
cargo install ripgrep
cargo install fd-find

#neovim
sudo add-apt-repository ppa:jonathonf/python-3.6 -y
sudo add-apt-repository ppa:neovim-ppa/stable -y
sudo apt update
sudo apt install python3.6 -fqy
sudo apt install python3-pip -qy
/usr/bin/python3.6 -m pip install --user pynvim
sudo apt-get install neovim -qy
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#fonts
#sudo apt install fonts-font-awesome
cd Downloads
curl -OJL http://mirrors.kernel.org/ubuntu/pool/main/f/fonts-font-awesome/fonts-font-awesome_5.0.10+really4.7.0~dfsg-1_all.deb
sudo apt install ./fonts-font-awesome_5.0.10+really4.7.0~dfsg-1_all.deb -qy
cd ~
sudo apt install fonts-powerline -qy

#i3status-rust
sudo apt install libdbus-1-dev -qy #only on 16.04
git clone https://github.com/greshake/i3status-rust
cd i3status-rust && cargo build --release
mkdir -p ~/bin
cp target/release/i3status-rs ~/bin/i3status-rs
cd ~

#get configs
git clone https://github.com/goirad/config
mkdir -p ~/.config/i3
mkdir -p ~/.config/nvim
cp config/i3/* ~/.config/i3
cp config/nvim/* ~/.config/nvim/
cp config/.bashrc ~/.bashrc
cp config/redshift.conf ~/.config/

#install neovim plugins then exit
nvim +'PlugInstall --sync' +qa

#i3
/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2019.02.01_all.deb keyring.deb SHA256:176af52de1a976f103f9809920d80d02411ac5e763f695327de9fa6aff23f416
sudo dpkg -i keyring.deb

sudo add-apt-repository "deb http://debian.sur5r.net/i3/ xenial universe" -y
sudo apt update -q
sudo apt install i3 -qy

# fix nautilus bug for i3
gsettings set org.gnome.desktop.background show-desktop-icons false


