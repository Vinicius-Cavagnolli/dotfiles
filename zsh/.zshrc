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

# ollama
export OLLAMA_API_BASE=http://127.0.0.1:11434

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "~/.local/share/reflex/bun/_bun" ] && source "~/.local/share/reflex/bun/_bun"
# bun end

# go
export PATH=$PATH:/usr/local/go/bin

# aider
export PATH="$HOME/.local/bin:$PATH"

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
