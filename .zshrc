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
--color=bg+:#3c3836,bg:#282828,spinner:#b8bb26,hl:#fb4934 \
--color=fg:#ebdbb2,header:#b8bb26,info:#83a598,pointer:#d79921 \
--color=marker:#b16286,fg+:#ebdbb2,prompt:#d79921,hl+:#fb4934 \
--color=selected-bg:#504945 \
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
alias lg="lazygit"
alias ld="lazydocker"

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
 
# Conan settings for work
export GITLAB_CONAN_PASSWORD="3vmZpg92QMSUJ913cXms"
export CONAN_ENV_PATH='/home/ldcrainic/.env/conan/bin/activate'
export CONAN_USER="ldcrainic"
alias CONAN_START='conan user ldcrainic -r gitlab -p $GITLAB_CONAN_PASSWORD'
function conan_init() {
    source "$CONAN_ENV_PATH"
    CONAN_START
    figlet -c -f ANSIShadow "CONGO"
}
alias congo="conan_init"
 
# This handles the docker problems on my work machine that uses podman
export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock
 
 
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"
 
 
# Virtual Env Wrapper settings for Python
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_VIRTUALENV=~/.local/bin/virtualenv
source ~/.local/bin/virtualenvwrapper.sh
 
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
 
 