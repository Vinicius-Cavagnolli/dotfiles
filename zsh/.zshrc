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

# Accept autosuggestion with double tab
bindkey '^I^I' autosuggest-accept

# Bash-like word selection for navigation
autoload -U select-word-style
select-word-style bash

# basic path export
export PATH="$HOME/.local/bin:$PATH"

# go
export PATH=$PATH:/usr/local/go/bin

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
# nvm end

# uv
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
# uv end

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# vscode
export PATH=$PATH:/usr/local/bin
