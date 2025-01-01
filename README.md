# Setup

Install brew then run the following to install to brew file

```sh
brew bundle
```

Clone the repo down

```sh
git clone --bare https://github.com/AnthonyPoschen/dotfiles $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
```

Install brew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Brew might not be in path so might need to fix that / run binary directly
brew bundle
```

swap to kitty terminal before proceeding.

Install ohmyzsh

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
```

config may be required for oh my zsh

Install tmux plugin manager

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Install tmux plugins with following hotkey Ctrl+A I

```sh
^A + I
```

Install zsh zplug plugins

```sh
zplug install
```

Setting up p10k
install custom fonts before setting up zsh

```sh
https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

```

Installing oh-my-zsh plugins

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
```

Configuring podman post install

```sh
podman machine init --cpu 8 --memory=8192
podman machine ssh sudo rpm-ostree install qemu-user-static
podman machine ssh sudo systemctl reboot
```

Configure golang packages that aren't managed elsewhere

```sh

```

configuring fonts:
[fragment mono: https://fonts.google.com/specimen/Fragment+Mono]

Configuring macos editing:
tinkertool for disabling animations and annoying shit: https://www.bresink.com/osx/0TinkerTool/download.php
LinearMouse: https://linearmouse.app
