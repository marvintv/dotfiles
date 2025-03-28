# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load completion system early
autoload -Uz compinit
compinit

# ======================
# ZSH Configuration
# ======================

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY

# Enable Powerlevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load Powerlevel10k (if not already loaded)
if [[ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source ~/powerlevel10k/powerlevel10k.zsh-theme
else
    echo "Powerlevel10k not found. Install it with:"
    echo "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k"
fi

# ======================
# Environment Variables
# ======================

# Set PATH to include system binaries and user-specific directories
export PATH="/bin:/usr/bin:/usr/local/bin:$HOME/Library/Python/3.13/bin:$HOME/.local/bin:$PATH"

# Source additional environment settings (if the file exists)
if [[ -f "$HOME/.local/bin/env" ]]; then
    source "$HOME/.local/bin/env"
fi

# ======================
# Aliases
# ======================

# Activate the aider virtual environment
# alias aiderenv="source /Users/marvinvilaysack/aider-env/bin/activate"

# Common shortcuts
alias ll="ls -la"  # List all files in long format
alias cls="clear"  # Clear the terminal screen
alias copy="pbcopy"
alias gds="git diff HEAD --stat"
alias lg="lazygit"
# git aliases
alias gs="git status"
alias dot="cd ~/dotfiles"
alias pn="pnpm"
# ======================
# Custom Functions
# ======================

# Create a new directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ======================
# Plugins (Optional)
# ======================

# Enable ZSH plugins (if using Oh My Zsh or similar)
# Example:
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# ======================
# Miscellaneous
# ======================

# Set default editor (e.g., nano or vim)
export EDITOR="nvim"

# Enable color support for commands like ls
export CLICOLOR=1
export LSCOLORS="ExFxBxDxCxegedabagacad"


alias lt='eza --tree --level=2 --long --icons --git'




# aerospace
alias as='aerospace'
function ff() {
    aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}




# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias gl="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dc="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."


# ======================
# End of Configuration
# ======================
source ~/powerlevel10k/powerlevel10k.zsh-theme

# Handle window resize properly
TRAPWINCH() {
  zle && zle reset-prompt
  tput clear  # Clear the screen
  prompt_p10k_setup  # Redraw prompt (for Powerlevel10k)
}

# Enable better resizing support
setopt promptsubst
setopt NO_PROMPT_CR

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias python="python3"
export PATH="/Users/marvinvilaysack/Library/Python/3.9/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

## alias
#
#alias vi='nvim'

alias vi='nvim'
DISABLE_AUTO_TITLE="true"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fzf_cd() {
  # Find directories and let fzf select one
  local dir
  dir=$(find . -type d 2> /dev/null | fzf +m) && cd "$dir"
}
alias fcd=fzf_cd


# Function to add and push updates to dotfiles with chezmoi
function chezmoi_push() {
    chezmoi add ~/.zshrc
    cd ~/.local/share/chezmoi || { echo "chezmoi directory not found"; return 1; }
    git commit -am "Updated .zshrc"
    git push
    echo "Dotfiles updated and pushed successfully!"
}

# Pretty print aliases and functions
function zlist() {
    echo -e "\n\033[1;34m=== Custom Aliases ===\033[0m"
    grep '^alias ' ~/.zshrc | awk -F'=' '{printf "\033[1;32m%-20s\033[0m %s\n", $1, $2}' | column -t -s '='

    echo -e "\n\033[1;34m=== Custom Functions ===\033[0m"
    grep '^function ' ~/.zshrc | awk '{print "\033[1;36m" $0 "\033[0m"}'

    echo -e "\n\033[1;34m=== End of List ===\033[0m"
}

# Short alias for easy access
alias zcmds="zlist"
## kubectl commads
alias k="kubectl"
alias kgp="kubectl get pods"
# Enable autocompletion
autoload -Uz compinit
compinit
alias config='cd ~/.config'


function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

#attach session tmux
#
function tmux_last_session(){

    LAST_TMUX_SESSION=$(tmux list-sessions | awk -F ":" '{print$1}' | tail -n1);
    tmux attach -t $LAST_TMUX_SESSION
}
bindkey -s '^s' 'tmux_last_session ^M'

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/marvinvilaysack/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
# Autoload compinit is now at the top of the file

# kubectl completion (will now work properly with compinit loaded above)
[[ $commands[kubectl] ]] && source <(kubectl completion zsh) # add autocomplete permanently to your zsh shell

export PATH=~/.npm-global/bin:$PATH

### Added by Claude for zinit installation ###
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of zinit installation ###

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
