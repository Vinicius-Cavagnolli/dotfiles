#!/bin/bash

# +--------------------------------------+
# |             Variables                |
# +--------------------------------------+
# Colors
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RED="\033[0;31m"
RESET="\033[0m"

# Directories
DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
FONT_DIR="$HOME/.local/share/fonts"
VIMRC_SOURCE="$DOTFILES_DIR/vim/.vimrc"
VIMRC_TARGET="$HOME/.vimrc"
AUTOLOAD_DIR="$HOME/.vim/autoload"
PLUG_DIR="$HOME/.vim/plugged"
PLUG_FILE="$AUTOLOAD_DIR/plug.vim"
ALACRITTY_DIR="$HOME/.config/alacritty"
ALACRITTY_TARGET="$ALACRITTY_DIR/alacritty.toml"
ALACRITTY_SOURCE="$DOTFILES_DIR/alacritty/alacritty.toml"
THEMES_DIR="$ALACRITTY_DIR/themes"
ZSHRC_SOURCE="$DOTFILES_DIR/zsh/.zshrc"
ZSHRC_TARGET="$HOME/.zshrc"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
ZSH_PLUGINS_DIR="$ZSH_CUSTOM/plugins"

# Git sources
FZF_GIT_REPO="https://github.com/junegunn/fzf.git"
VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
ALACRITTY_THEME_REPO="https://github.com/alacritty/alacritty-theme.git"
JETBRAINS_MONO_ZIP="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
ZSH_SYNTAX_HIGHLIGHTING_REPO="https://github.com/zsh-users/zsh-syntax-highlighting.git"
ZSH_AUTOSUGGESTIONS_REPO="https://github.com/zsh-users/zsh-autosuggestions.git"
ZSH_SHIFT_SELECT_REPO="https://github.com/jeffreytse/zsh-shift-select.git"


# +--------------------------------------+
# |               Helpers                |
# +--------------------------------------+
info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET} $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error() { echo -e "${RED}[ERROR]${RESET} $1"; }


# +--------------------------------------+
# |                START                 |
# +--------------------------------------+
info "Starting environment setup."
warn "You will be prompted for the sudo password as needed."


# +--------------------------------------+
# |          Dependency Check            |
# +--------------------------------------+
echo ""
info "Checking dependencies..."

check_dep() {
  if ! command -v "$1" &>/dev/null; then
    error "Missing dependency: $1"
    MISSING_DEPS=true
  else
    success "$1 is installed."
  fi
}

MISSING_DEPS=false

check_dep "vim"
check_dep "curl"
check_dep "npm"
check_dep "git"

if [ "$MISSING_DEPS" = true ]; then
  echo ""
  error "Some dependencies are missing. Please install them and re-run this script."
  exit 1
fi


# +--------------------------------------+
# |                 Vim                  |
# +--------------------------------------+
echo ""
info "Linking .vimrc..."

if [ -e "$VIMRC_TARGET" ] && [ ! -L "$VIMRC_TARGET" ]; then
  warn "~/.vimrc already exists. Backing it up to ~/.vimrc.backup"
  mv "$VIMRC_TARGET" "$VIMRC_TARGET.backup"
fi

ln -sf "$VIMRC_SOURCE" "$VIMRC_TARGET"
success "Symlinked $VIMRC_SOURCE → $VIMRC_TARGET"

echo ""
info "Checking for ripgrep (rg)..."

if ! command -v rg &>/dev/null; then
  warn "ripgrep (rg) not found. Attempting to install..."

  if command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y ripgrep && success "ripgrep installed via apt-get."
  else
    warn "Please install ripgrep (rg) manually: https://github.com/BurntSushi/ripgrep"
  fi
else
  success "ripgrep (rg) is already installed."
fi

echo ""
info "Checking for fzf..."

if ! command -v fzf &>/dev/null; then
  warn "fzf not found. Installing fzf..."

  if git clone --depth 1 "$FZF_GIT_REPO" ~/.fzf && ~/.fzf/install --key-bindings --completion --no-update-rc; then
    success "fzf installed successfully."
  else
    error "Failed to install fzf."
    exit 1
  fi
else
  success "fzf is already installed."
fi

echo ""
info "Installing vim-plug..."

if [ ! -f "$PLUG_FILE" ]; then
  mkdir -p "$AUTOLOAD_DIR" "$PLUG_DIR"
  if curl -fLo "$PLUG_FILE" --create-dirs "$VIM_PLUG_URL"; then
    success "vim-plug installed successfully."
  else
    error "Failed to download vim-plug."
    exit 1
  fi
else
  success "vim-plug already installed."
fi

echo -e "${YELLOW}→ Open Vim and run :PlugInstall to install your plugins.${RESET}"


# +--------------------------------------+
# |               pyright                |
# +--------------------------------------+
echo ""
info "Checking for pyright..."

if ! command -v pyright &>/dev/null; then
  info "Installing pyright globally via npm..."
  if sudo npm install -g pyright; then
    success "pyright installed successfully."
  else
    error "Failed to install pyright. Check your npm setup."
    exit 1
  fi
else
  success "pyright is already installed."
fi


# +--------------------------------------+
# |                  Zsh                 |
# +--------------------------------------+
echo ""
info "Setting Zsh as the default shell for the current user..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh framework..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && success "Oh My Zsh installed."
else
  success "Oh My Zsh already installed."
fi

if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)" "$USER" && success "Default shell changed to Zsh."
else
  success "Default shell is already Zsh."
fi

echo ""
info "Linking .zshrc..."

if [ -e "$ZSHRC_TARGET" ] && [ ! -L "$ZSHRC_TARGET" ]; then
  warn "~/.zshrc already exists. Backing it up to ~/.zshrc.backup"
  mv "$ZSHRC_TARGET" "$ZSHRC_TARGET.backup"
fi

ln -sf "$ZSHRC_SOURCE" "$ZSHRC_TARGET"
success "Symlinked $ZSHRC_SOURCE → $ZSHRC_TARGET"

echo ""
info "Setting Zsh plugins..."

install_plugin() {
  local plugin_name=$1
  local repo_url=$2
  local target_dir="$ZSH_PLUGINS_DIR/$plugin_name"

  if [ ! -d "$target_dir" ]; then
    info "Installing $plugin_name..."
    if git clone --depth 1 "$repo_url" "$target_dir"; then
      success "$plugin_name installed."
    else
      warn "Failed to install $plugin_name from $repo_url"
    fi
  else
    success "$plugin_name is already installed."
  fi
}

install_plugin "zsh-syntax-highlighting" "$ZSH_SYNTAX_HIGHLIGHTING_REPO"
install_plugin "zsh-autosuggestions" "$ZSH_AUTOSUGGESTIONS_REPO"
install_plugin "zsh-shift-select" "$ZSH_SHIFT_SELECT_REPO"


# +--------------------------------------+
# |        JetBrainsMono Nerd Font       |
# +--------------------------------------+
echo ""
info "Checking for JetBrainsMono Nerd Font..."

if ! fc-list | grep -iq "JetBrainsMono Nerd Font"; then
  warn "JetBrainsMono Nerd Font not found. Installing..."

  mkdir -p "$FONT_DIR"
  TEMP_ZIP="/tmp/jetbrainsmono.zip"

  if curl -L -o "$TEMP_ZIP" "$JETBRAINS_MONO_ZIP"; then
    info "Downloaded JetBrainsMono Nerd Font archive."
    unzip -o "$TEMP_ZIP" -d "$FONT_DIR"
    fc-cache -f -v
    success "JetBrainsMono Nerd Font installed successfully."
    rm "$TEMP_ZIP"
  else
    error "Failed to download JetBrainsMono Nerd Font."
    exit 1
  fi
else
  success "JetBrainsMono Nerd Font already installed."
fi


# +--------------------------------------+
# |              Alacritty               |
# +--------------------------------------+
echo ""
info "Linking alacritty.toml..."

if ! command -v alacritty &>/dev/null; then
  warn "Alacritty is not installed. Please install it manually for terminal configuration to apply."
else
  mkdir -p "$ALACRITTY_DIR"

  if [ -e "$ALACRITTY_TARGET" ] && [ ! -L "$ALACRITTY_TARGET" ]; then
    warn "Existing Alacritty config found. Backing it up to alacritty.toml.backup"
    mv "$ALACRITTY_TARGET" "$ALACRITTY_TARGET.backup"
  fi

  ln -sf "$ALACRITTY_SOURCE" "$ALACRITTY_TARGET"
  success "Symlinked $ALACRITTY_SOURCE → $ALACRITTY_TARGET"
fi

echo ""
info "Setting up theme for Alacritty..."

if [ ! -d "$THEMES_DIR" ]; then
  warn "Installing themes at $THEMES_DIR..."
  if git clone "$ALACRITTY_THEME_REPO" "$THEMES_DIR"; then
    success "Alacritty themes installed to $THEMES_DIR."
  else
    error "Failed to clone alacritty-theme."
    exit 1
  fi
else
  success "Alacritty themes already installed."
fi


# +--------------------------------------+
# |                 END                  |
# +--------------------------------------+
echo ""
info "Setup complete!"
