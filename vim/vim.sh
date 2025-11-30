#!/bin/sh

VIM_SRC_DIR="$HOME/.local/src/vim"
VIM_INSTALL_DIR="/usr/local"
AUTOLOAD_DIR="$HOME/.vim/autoload"
PLUG_DIR="$HOME/.vim/plugged"
PLUG_FILE="$AUTOLOAD_DIR/plug.vim"
VIM_REPO="https://github.com/vim/vim.git"
VIM_PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

echo "Checking vim installed flags..."

check_vim_features() {
  vim_version=$(vim --version 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    echo "nok"
    return
  fi

  if echo "$vim_version" | grep -qi "Huge version" && \
     echo "$vim_version" | grep -qi "+eval" && \
     echo "$vim_version" | grep -qi "+python3" && \
     echo "$vim_version" | grep -qi "+syntax"; then
    echo "ok"
  else
    echo "nok"
  fi
}

if [[ $(check_vim_features) == "nok" ]]; then
  echo "Vim not installed or lacking some features. Building it from source..."

  echo "Cloning Vim source to $VIM_SRC_DIR"
  rm -rf "$VIM_SRC_DIR"
  mkdir -p "$(dirname "$VIM_SRC_DIR")"
  git clone "$VIM_REPO" "$VIM_SRC_DIR"
  cd "$VIM_SRC_DIR"

  ./configure \
    --with-features=huge \
    --enable-python3interp=yes \
    --enable-rubyinterp=yes \
    --enable-luainterp=yes \
    --enable-perlinterp=yes \
    --enable-clipboard=yes \
    --enable-multibyte \
    --enable-terminal \
    --without-x \
    --disable-gui \
    --without-xpm \
    --without-gtk \
    --without-athena \
    --without-motif \
    --enable-cscope \
    --prefix=$VIM_INSTALL_DIR

  make -j"$(nproc)"
  sudo make install
  echo "Vim build and install completed."

  rm -rf "$VIM_SRC_DIR"
else
  echo "Vim installation is already OK."
fi

echo "Installing vim-plug..."

if [ ! -f "$PLUG_FILE" ]; then
  mkdir -p "$AUTOLOAD_DIR" "$PLUG_DIR"
  if curl -fLo "$PLUG_FILE" --create-dirs "$VIM_PLUG_URL"; then
    echo "vim-plug installed successfully."
  else
    echo "Failed to download vim-plug."
    exit 1
  fi
else
  echo "vim-plug already installed."
fi

echo -e "→ Open Vim and run :PlugInstall to install your plugins."
