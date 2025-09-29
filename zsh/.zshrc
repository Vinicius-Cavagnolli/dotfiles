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

# Ollama
export OLLAMA_API_BASE=http://127.0.0.1:11434

# Paths
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"  # Bun
export BUN_INSTALL="$HOME/.bun" # Bun
export PATH="$BUN_INSTALL/bin:$PATH" # Bun
[ -s "~/.local/share/reflex/bun/_bun" ] && source "~/.local/share/reflex/bun/_bun" # Bun
export PATH=$PATH:/usr/local/go/bin # Go
export PATH="$HOME/.local/bin:$PATH" # Aider
export NVM_DIR="$HOME/.nvm" # NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # NVM
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # NVM
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
