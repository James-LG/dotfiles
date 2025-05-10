# dotfiles

My personal dotfiles.
Use at your own peril.

## Usage

Install with stow using the following command from inside this repo.

```sh
stow -v -R -t ~ home
```

# Manjaro

Various packages to install

```sh
sudo pamac install neovim luarocks ripgrep rust nodejs npm yarn fzf codespell fd
cargo install tmux-sessionizer
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
