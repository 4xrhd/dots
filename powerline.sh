#!/bin/bash
mkdir -p ~/src/github.com/powerline/
cd ~/src/github.com/powerline/
rm -rf fonts
git clone https://github.com/powerline/fonts
cd fonts
./install.sh

