#!/bin/sh

VIM_WAYLAND_PACK_DIR="$HOME/.vim/pack/vim-wayland-clipboard/start"
VIM_WAYLAND_CLIP_REPO="https://github.com/jasonccox/vim-wayland-clipboard.git"

if [ ! -d "$VIM_WAYLAND_PACK_DIR/vim-wayland-clipboard" ]; then
  mkdir -p "$VIM_WAYLAND_PACK_DIR"
  git clone "$VIM_WAYLAND_CLIP_REPO" "$VIM_WAYLAND_PACK_DIR/vim-wayland-clipboard"
  echo "Cloned vim-wayland-clipboard."
else
  echo "vim-wayland-clipboard already set up."
fi
