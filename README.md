# Setup
Install brew then run the following to install to brew file
```
brew bundle
```

Clone the repo down
```
git clone --bare https://github.com/AnthonyPoschen/dotfiles $HOME/.cfg
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout
```
Install brew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Brew might not be in path so might need to fix that / run binary directly
brew bundle
```

swap to kitty terminal before proceeding.

Install ohmyzsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
```
config may be required for oh my zsh

Install tmux plugin manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Install tmux plugins with following hotkey Ctrl+A I
```
^A + I
```

Setting up p10k
install custom fonts before setting up zsh
```
https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

```
Installing oh-my-zsh plugins
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
```


Configuring podman post install
```
podman machine init --cpu 8 --memory=8192
podman machine ssh sudo rpm-ostree install qemu-user-static
podman machine ssh sudo systemctl reboot
```
