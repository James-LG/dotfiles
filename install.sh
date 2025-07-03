#!/bin/zsh

set -e

cd packages
stow -v -R -t $HOME *
