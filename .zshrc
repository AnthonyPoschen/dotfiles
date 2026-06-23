# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
#
if [[ $(uname) == "Darwin" ]]; then
	export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
fi
if [[ -z "$TMUX" && $- == *i* && -z "$VIM" ]]; then
	tmux attach || exec tmux new-session -s home && tmux kill-server && exit
fi
fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
# NOTE: Prompt experiment - Powerlevel10k instant prompt is disabled while trying Starship.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh-custom"
# NOTE: Prompt experiment - Starship is enabled near the end of this file.
# Keep Powerlevel10k disabled while trying Starship so the prompts do not fight.
# ZSH_THEME="powerlevel10k/powerlevel10k"
# Zsh autosuggest
bindkey -M viins '^y' autosuggest-accept
bindkey -M viins '^ ' autosuggest-accept
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8D8D8D,bold"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"

export ZPLUG_HOME=/usr/local/opt/zplug
if [[ $(uname) == "Darwin" ]]; then
	export ZPLUG_HOME="/opt/homebrew/opt/zplug"
fi
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
# palette - prints color palette
# printc prints the palette color as a code to use in PS1
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --smart-case --glob "!.git/*"'
zstyle ':fzf-tab:*' default-color $'\033[38;5;255m'
FZF_TAB_GROUP_COLORS=(
	$'\033[94m' $'\033[32m' $'\033[33m' $'\033[35m' $'\033[31m' $'\033[38;5;27m' $'\033[36m'
	$'\033[38;5;100m' $'\033[38;5;98m' $'\033[91m' $'\033[38;5;80m' $'\033[92m'
	$'\033[38;5;214m' $'\033[38;5;165m' $'\033[38;5;124m' $'\033[38;5;120m'
)
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS
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
# Keep Ctrl-C as an interrupt in all ZLE keymaps. Without this, vi insert mode
# can treat Ctrl-C as self-insert and Starship redraws may print literal
# command substitutions (especially on macOS).
bindkey -M viins '^C' send-break
bindkey -M vicmd '^C' send-break
bindkey -M emacs '^C' send-break
# export KEYTIMEOUT=1
export KEYTIMEOUT=20
# TODO: Remove this jj prefix when my brain no longer needs it, escape is easy now
# bindkey -M viins 'jj' vi-cmd-mode
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
alias ls='ls -alGh'
alias rg='rg -i'
alias Rg='rg -i'

# https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
# # for 256 color support
# if [ -n "$TMUX" ]; then
#     export TERM=screen-256color
# else
#     export TERM=xterm-256color
# fi

# make jq use nicer colour printing
export JQ_COLORS="0;90:0;39:0;39:0;39:0;32:1;39:1;39:1;34"
# make vim as default editor
export EDITOR=nvim

export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:$HOME/.bin"
export PATH="$PATH:$HOME/.node_modules_global/bin"
export PATH="$PATH:$HOME/.gem/ruby/2.5.0/bin"
export PATH="$PATH:$HOME/.krew/bin"
export PATH="$PATH:$HOME/.zvm/bin"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export DOCKER_BUILDKIT=1
export DOCKER_DEFAULT_PLATFORM=linux/amd64
# NOTE: Prompt experiment - Powerlevel10k is disabled while trying Starship.
# To re-enable p10k, uncomment ZSH_THEME above and the source line below, then
# comment out the Starship init line.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NOTE: Prompt experiment - Starship prompt.
# eval "$(starship init zsh)"

#NOTE: oh-my-posh
# https://ohmyposh.dev/docs/installation/prompt
export POSH_THEME="$HOME/.config/oh-my-posh/theme.json"
eval "$(oh-my-posh --config "$POSH_THEME" init zsh)"

_omp_secondary_prompt=$("$_omp_executable" --config "$POSH_THEME" print secondary --shell=zsh)

function _omp_get_prompt() {
	local type=$1
	local args=("${@[2,-1]}")
	"$_omp_executable" --config "$POSH_THEME" print "$type" \
		--save-cache \
		--shell=zsh \
		--shell-version=$ZSH_VERSION \
		--status=$_omp_status \
		--pipestatus="${_omp_pipestatus[*]}" \
		--no-status=$_omp_no_status \
		--execution-time=$_omp_execution_time \
		--job-count=$_omp_job_count \
		--stack-count=$_omp_stack_count \
		--terminal-width="${COLUMNS-0}" \
		${args[@]}
}

autoload -Uz add-zsh-hook
function _prompt_spacer() {
	if [[ -n "${_prompt_spacer_seen:-}" ]]; then
		print
	else
		typeset -g _prompt_spacer_seen=1
	fi
}
add-zsh-hook precmd _prompt_spacer
# END: oh-my-posh

unset POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND
unset POWERLEVEL9K_AWS_SHOW_ON_COMMAND
unset ZSH_AUTOSUGGEST_USE_ASYNC
export COLUMNS="120"

########################
# Notes:
# to download kubernetes schema
# pip install openapi2jsonschema
# kubectl proxy --port=8080
# curl localhost:8080/openapi/v2 > k8s-swagger.json
# openapi2jsonschema -o "schemas" --kubernetes --stand-alone k8s-swagger.json
# then use the output as the yaml jsonschema for k8s files

# # The next line updates PATH for the Google Cloud SDK.
# if [ -f '/Users/zanven/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/zanven/Downloads/google-cloud-sdk/path.zsh.inc'; fi
#
# # The next line enables shell command completion for gcloud.
# if [ -f '/Users/zanven/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/zanven/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Added by GDK bootstrap
# source /Users/zanven/.asdf/asdf.sh
if command -v mise >/dev/null 2>&1; then
	eval "$(mise activate zsh)"
fi

# setup clipboard with system clipboard for zshrc vi mode
if [ -f ~/.zshrc-clipboard ]; then
	source ~/.zshrc-clipboard
fi

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<
