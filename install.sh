#!/bin/bash

set -x

ln -s ~/.config/.Xdefaults ~/.Xdefaults
ln -s ~/.config/emacs/.emacs ~/.emacs
ln -s ~/.config/gtk-2.0/gtkrc ~/.gtkrc-2.0

ln -s ~/.config/.bash_profile ~/.bash_profile
ln -s ~/.config/.bashrc ~/.bashrc
ln -s ~/.config/.gitconfig ~/.gitconfig
ln -s ~/.config/.xinitrc ~/.xinitrc

ln -s ~/.config/.zshrc ~/.zshrc
ln -s ~/.config/.zprofile ~/.zprofile
ln -s ~/.config/.zcompdump ~/.zcompdump

ln -s ~/.config/.asoundrc ~/.asoundrc

sudo ln -s ~/.config/touchpad/30-touchpad.conf /etc/X11/xorg.conf.d/30-touchpad.conf
