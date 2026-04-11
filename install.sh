#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Dotfiles installer"
echo "    Dotfiles directory: $DOTFILES_DIR"

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  echo "==> Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install stow if not present
if ! command -v stow &>/dev/null; then
  echo "==> Installing GNU Stow..."
  brew install stow
fi

# Remove existing symlinks that point to old dotfiles locations
for dir in nvim tmux aerospace opencode; do
  target="$HOME/.config/$dir"
  if [ -L "$target" ]; then
    echo "==> Removing old symlink: $target"
    rm "$target"
  fi
done

# Create symlinks via stow
echo "==> Creating symlinks with GNU Stow..."
cd "$DOTFILES_DIR"
stow -t ~ home

echo "==> Done! Config symlinks created in ~/.config/"
