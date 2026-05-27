#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -t 1 ]; then
  C_BLUE=$'\033[1;34m'
  C_GREEN=$'\033[1;32m'
  C_YELLOW=$'\033[1;33m'
  C_RESET=$'\033[0m'
else
  C_BLUE=''; C_GREEN=''; C_YELLOW=''; C_RESET=''
fi

info()    { echo "${C_BLUE}==>${C_RESET} $*"; }
success() { echo "${C_GREEN}==>${C_RESET} $*"; }
warn()    { echo "${C_YELLOW}==>${C_RESET} $*"; }

installed_brew=0
installed_stow=0
removed_links=()
stowed_packages=()

info "Dotfiles installer"
echo "    Dotfiles directory: $DOTFILES_DIR"

if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  installed_brew=1
fi

if ! command -v stow &>/dev/null; then
  info "Installing GNU Stow..."
  brew install stow
  installed_stow=1
fi

# Ensure Node.js is available (needed for pi)
if ! command -v node &>/dev/null; then
  info "Installing Node.js via nvm..."
  if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  fi
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install --lts
fi

# Install pi if not present (needed for packages)
if ! command -v pi &>/dev/null; then
  info "Installing pi coding agent..."
  npm install -g @earendil-works/pi-coding-agent
fi

# Remove existing symlinks for any package we're about to stow
if [ -d "$DOTFILES_DIR/home/.config" ]; then
  for path in "$DOTFILES_DIR"/home/.config/*/; do
    [ -d "$path" ] || continue
    name=$(basename "$path")
    target="$HOME/.config/$name"
    if [ -L "$target" ]; then
      warn "Removing old symlink: $target"
      rm "$target"
      removed_links+=("$name")
    fi
  done
fi

# Remove existing files/symlinks that stow will replace under ~/.pi
# This includes old symlinks from ~/.agents/skills/ that stow will replace
if [ -d "$DOTFILES_DIR/home/.pi" ]; then
  for path in $(cd "$DOTFILES_DIR/home" && find .pi -type f); do
    target="$HOME/$path"
    if [ -L "$target" ] || [ -f "$target" ]; then
      warn "Removing old file/symlink: $target"
      rm "$target"
      removed_links+=("$path")
    fi
  done
  # Also remove old symlinks for skill directories (stow needs the parent dirs clean)
  for path in $(cd "$DOTFILES_DIR/home" && find .pi -type d); do
    target="$HOME/$path"
    if [ -L "$target" ]; then
      warn "Removing old symlink directory: $target"
      rm "$target"
      removed_links+=("$path")
    fi
  done
fi

info "Creating symlinks with GNU Stow..."
cd "$DOTFILES_DIR"
stow -t ~ home
for path in "$DOTFILES_DIR"/home/.config/*/; do
  [ -d "$path" ] || continue
  stowed_packages+=("$(basename "$path")")
done

# Install pi packages from settings.json
if command -v pi &>/dev/null; then
  info "Installing pi packages..."
  # Extract package names from settings.json and install each
  pkg_count=0
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    info "  Installing pi package: $pkg"
    if pi packages install "$pkg" 2>/dev/null; then
      pkg_count=$((pkg_count + 1))
    else
      warn "  Failed to install: $pkg (may need manual install)"
    fi
  done < <(python3 -c "
import json, sys
try:
    s = json.load(open('$HOME/.pi/agent/settings.json'))
    for p in s.get('packages', []):
        print(p)
except: pass
" 2>/dev/null)
  if [ $pkg_count -gt 0 ]; then
    success "Installed $pkg_count pi package(s)"
  fi
else
  warn "pi not found in PATH — skip pi package install. Run 'pi packages install <pkg>' manually after installing pi."
fi

echo
success "Done!"
echo "    Homebrew:      $([ $installed_brew -eq 1 ] && echo 'installed' || echo 'already present')"
echo "    GNU Stow:      $([ $installed_stow -eq 1 ] && echo 'installed' || echo 'already present')"
echo "    Removed links: ${#removed_links[@]}${removed_links:+ (${removed_links[*]})}"
echo "    Stowed:        ${#stowed_packages[@]} (${stowed_packages[*]})"
