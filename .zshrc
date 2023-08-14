# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh-custom"
ZSH_THEME="powerlevel10k/powerlevel10k"
# Zsh autosuggest
bindkey -M viins '^ ' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8D8D8D,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"

# export ZPLUG_HOME=/usr/local/opt/zplug
export ZPLUG_HOME=$(brew --prefix)/opt/zplug
source $ZPLUG_HOME/init.zsh

# temp fixes
# export PATH="/usr/local/opt/node@16/bin:$PATH"
# source ~/.kubectl-completion
# source <(kubectl completion bash)
source ~/.aliases
# git status on right prompt
setopt prompt_subst
source ~/.git-prompt.sh

# export HTTP_PROXY=`scutil --proxy | awk '\
#   /HTTPEnable/ { enabled = $3; } \
#   /HTTPProxy/ { server = $3; } \
#   /HTTPPort/ { port = $3; } \
#   END { if (enabled == "1") { print "http://" server ":" port; } }'`
# export HTTPS_PROXY="${HTTP_PROXY}"
# Let fzf use rg


plugins=(
    aws
    # battery
    branch
    colored-man-pages
    docker
    encode64
    extract
    git
    gitfast
    git-escape-magic
    git-prompt
    helm
    # kubectl
    rsync
    # themes
    wd
    web-search
    kube-ps1
    macos
    fzf-tab
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

# Self update zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Command completions
# zplug "zsh-users/zsh-completions"

# Syntax highlighting for commands
zplug "zsh-users/zsh-syntax-highlighting"

# Quickly search history
zplug "zsh-users/zsh-history-substring-search", defer:2

zplug load
#### zPlug ####


# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
# [[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
# [[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --smart-case --glob "!.git/*"'

# export RPROMPT=$'%F{blue}$(__git_ps1 "%s")$(kube_ps1)'
# export PROMPT='%F{yellow}%~ %b$%B%F{grey}%f%b '
# export GIT_PS1_SHOWDIRTYSTATE=1
# export KUBE_PS1_ENABLED=false

# history-substring bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# fpath=(#{HOMEBREW_PREFIX}/share/zsh-completions $fpath)
######## Configuration ############
# directory color fix
# eval `dircolors ~/.zshcolors`

# vi key bindings
bindkey -v
# export KEYTIMEOUT=1
export KEYTIMEOUT=20
bindkey -M viins 'jj' vi-cmd-mode
# history
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# case in-sensitive completion
# zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'

# useful alias
# alias ls='ls -G --color'
alias ll='ls -lhG '
alias ls='ls -G'
alias rg='rg -i'
alias Rg='rg -i'

# for 256 color support
if [ -n "$TMUX" ]; then
    export TERM=screen-256color
else
    export TERM=xterm-256color
fi

# make vim as default editor
export EDITOR=nvim

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.node_modules_global/bin"
export PATH="$PATH:$HOME/.gem/ruby/2.5.0/bin"
export PATH="$PATH:$HOME/.krew/bin"
export PATH="/usr/local/Cellar/openssh/8.3p1/bin:$PATH" # temporary fix till ssh fixes it shit in macos
export PATH="/usr/local/Cellar/openssh/8.3p1/sbin:$PATH" # temporary fix till ssh fixes it shit in macos

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/bin:$PATH"
export PATH="$PATH:/Users/zanven/istio-1.5.1/bin"

export DOCKER_DEFAULT_PLATFORM=linux/amd64
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export COLUMNS="120"

########################
# Notes:
# to download kubernetes schema
# pip install openapi2jsonschema
# kubectl proxy --port=8080
# curl localhost:8080/openapi/v2 > k8s-swagger.json
# openapi2jsonschema -o "schemas" --kubernetes --stand-alone k8s-swagger.json
# then use the output as the yaml jsonschema for k8s files

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zanven/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/zanven/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/zanven/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/zanven/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Added by GDK bootstrap
# source /Users/zanven/.asdf/asdf.sh
