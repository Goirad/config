#!/bin/bash

sudo apt install -qy \
    git git-lfs python3-pip build-essential blueman \
    curl htop scrot pavucontrol redshift \
    lm-sensors firefox xinit neovim shellcheck \
    fonts-font-awesome fonts-powerline fonts-firacode \
    libssl-dev libdbus-1-dev taskwarrior \
    cmake pkg-config libfreetype6-dev \
    libfontconfig1-dev libxcb-xfixes0-dev \
    i3 libsensors-dev nitrogen

#git
git config --global user.email "goiradio1@gmail.com"
git config --global user.name "Dario Gonzalez"
git config --global push.default simple
git config --global core.editor nvim

# where scrot will save images
mkdir -p ~/Pictures/Screenshots

#rust
if ! rustup --version &>/dev/null ; then
    curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
    source ~/.cargo/env
    rustup component add rust-analysis rust-src
fi

#utilities
cargo install ripgrep
cargo install fd-find
mkdir -p ~/oss
pushd ~/oss
git clone https://github.com/rust-analyzer/rust-analyzer.git
cd rust-analyzer
cargo xtask install --server
popd

#neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#i3status-rust
pushd oss
git clone https://github.com/greshake/i3status-rust
cd i3status-rust
cargo install --path ./
# to pick up artificats like themes and icons
./install.sh
popd

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

pip3 install --user pynvim --upgrade msgpack # for deoplete
#install neovim plugins then exit
nvim +'PlugInstall --sync' +qa
nvim +'UpdateRemotePlugins' +qa

pushd .vim/plugged/fzf
./install --all
popd

#alacritty
#first some build deps
cargo install --git https://github.com/alacritty/alacritty
sudo update-alternatives --install /usr/bin/x-terminal-emulator \
    x-terminal-emulator ~/.cargo/bin/alacritty 50

# fix nautilus bug for i3
gsettings set org.gnome.desktop.background show-desktop-icons false
