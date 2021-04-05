#!/usr/bin/env bash

echo "################################################################"
echo "Installing colorscripts"
echo "################################################################"
git clone https://gitlab.com/dwt1/shell-color-scripts.git

echo "----------------------------------------------------------------"
echo "cd to shell-color-scripts"
echo "----------------------------------------------------------------"
cd shell-color-scripts

echo "----------------------------------------------------------------"
echo "Builing shell-color-scripts"
echo "----------------------------------------------------------------"
makepkg -c

echo "----------------------------------------------------------------"
echo "Unziping shell-color-scripts"
echo "----------------------------------------------------------------"
pacman -U *.pkg.tar.zst

echo "################################################################"
echo "Enabling yay"
echo "################################################################"
echo "----------------------------------------------------------------"
echo "cd to /opt/"
echo "----------------------------------------------------------------"
cd /opt/
chown -Rv jordan:users ./yay
cd yay
makepkg -si

echo "################################################################"
echo "Finished. Be sure to rsync files from SSD, install yay packages, and run ':PlugInstall' inside .vimrc."
echo "################################################################"
