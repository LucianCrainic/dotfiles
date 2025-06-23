ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
	   mkdir -p "$(dirname $ZINIT_HOME)"
	      git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

autoload -Uz compinit && compinit

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
export EDITOR=nvim

export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#babbf1,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
--color=selected-bg:#51576d \
--multi \
--layout=reverse \
--border=rounded \
--no-scrollbar \
--pointer='>' \
--marker='*' \
--bold"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

ff() {
    local file
    file=$(find . -type f | fzf --preview 'cat {}' --preview-window right:60%:wrap)
    [[ -n "$file" ]] && $EDITOR "$file"
}

fd() {
    local dir
    dir=$(find . -type d | fzf --preview 'ls -la {}' --preview-window right:60%:wrap)
    [[ -n "$dir" ]] && cd "$dir"
}

if command -v fzf >/dev/null 2>&1; then
    bindkey '^T' ff                   # Ctrl+T for custom file fuzzy search with preview
    bindkey '^R' fzf-history-widget   # Ctrl+R for history fuzzy search
    bindkey '^[c' fd                  # Alt+C for directory fuzzy search
fi

eval "$(starship init zsh)"
# https://askubuntu.com/questions/1515760/unknown-option-bash-when-opening-the-terminal
eval "$(zoxide init zsh)"

if [[ "$OSTYPE" == "darwin"* ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

alias ..="cd .."
alias ...="cd ../.."
alias ~="cd ~"
alias -- -="cd -"

alias p="pwd"
alias v="nvim"

# Aliases: ls
alias l='eza -1A --group-directories-first --color=always --git-ignore'
alias ls='l'
alias la='l -l --time-style="+%Y-%m-%d %H:%M" --no-permissions --octal-permissions'
alias tree='l --tree'

# Aliases: git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(auto)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

gcm() { git commit --message "$*" }

# Aliases: tmux
alias ta='tmux attach'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'

alias rg="rg --hidden --smart-case --glob='!.git/' --no-search-zip --trim --colors=line:fg:black --colors=line:style:bold --colors=path:fg:magenta --colors=match:style:nobold"

# Work stuff
export GITLAB_CONAN_PASSWORD="3vmZpg92QMSUJ913cXms"
alias CONAN_START='conan user ldcrainic -r gitlab -p $GITLAB_CONAN_PASSWORD'
