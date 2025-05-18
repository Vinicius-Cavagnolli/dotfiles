export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="half-life"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  fzf
  zsh-shift-select
)

source $ZSH/oh-my-zsh.sh

bindkey '^I^I' autosuggest-accept  # Accept autosuggestion with double tab

# Bash-like word selection for navigation
autoload -U select-word-style
select-word-style bash

# Bun settings
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
