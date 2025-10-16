#!/bin/zsh

rclone bisync /home/jameslg/Documents/Obsidian onedrive:Documents/Obsidian --resync --resync-mode newer --create-empty-src-dirs --progress --verbose --transfers 10 --checkers 5

