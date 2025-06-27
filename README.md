# dotfiles

My personal dotfiles.
Use at your own peril.

## Usage

Install with stow using the following command from inside this repo.

```sh
stow -v -R -t ~ home
```

## Packages

```sh
sudo install dnf git neovim fzf zsh zsh-autosuggestions zsh-syntax-hightlighting
```

Installing tmux-sessionizer

```sh
sudo dnf install rustup
rustup-init
sudo dnf install perl-FindBin perl-IPC-Cmd perl-File-Compare
cargo install tmux-sessionizer
```

## Framework laptop Wifi issues

🔍 Analyzing modern disconnection patterns...
🛠️ === MODERN DISCONNECTION FIXES ===

🐧 Distribution: Fedora Linux 42 (Sway)

1. Modern driver reset:
   ⏰ IMMEDIATE (driver reload): sudo modprobe -r mt7925e && sleep 5 && sudo modprobe mt7925e

2. Distribution-specific firmware update:
   🔒 PERMANENT (system upgrade): sudo dnf update linux-firmware


🐧 Distribution-Specific Commands for Fedora Linux 42 (Sway):

1. Update firmware (most important for MediaTek):
   🔒 PERMANENT (system upgrade): sudo dnf update linux-firmware
   ⚠️ REQUIRES REBOOT: After firmware update

2. MediaTek-specific module configuration:
   🔒 PERMANENT (module config): echo 'options mt7921e disable_aspm=1' | sudo tee /etc/modprobe.d/mt7921e.conf
   🔒 PERMANENT (power config): echo 'options mt7921e power_save=0' | sudo tee -a /etc/modprobe.d/mt7921e.conf
   🔒 PERMANENT (apply config): sudo dracut -f
   ⚠️ REQUIRES REBOOT: After initrd rebuild

💡 TIP: Save these modern commands for future use!
📋 All solutions are tailored for your Fedora Linux 42 (Sway) system
