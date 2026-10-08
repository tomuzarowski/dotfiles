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
backed_up_dirs=()
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

# Top-level directories outside .config (e.g. ~/.warp) are linked as a whole,
# so back up real directories that apps created before the first install
for path in "$DOTFILES_DIR"/home/.[!.]*/; do
  [ -d "$path" ] || continue
  name=$(basename "$path")
  [ "$name" = ".config" ] && continue
  target="$HOME/$name"
  if [ -L "$target" ]; then
    warn "Removing old symlink: $target"
    rm "$target"
    removed_links+=("$name")
  elif [ -d "$target" ]; then
    backup="$target.backup-$(date +%Y%m%d%H%M%S)"
    warn "Backing up existing directory: $target -> $backup"
    mv "$target" "$backup"
    backed_up_dirs+=("$name")
  fi
done

info "Creating symlinks with GNU Stow..."
cd "$DOTFILES_DIR"
stow -t ~ home
for path in "$DOTFILES_DIR"/home/.config/*/; do
  [ -d "$path" ] || continue
  stowed_packages+=("$(basename "$path")")
done

echo
success "Done!"
echo "    Homebrew:      $([ $installed_brew -eq 1 ] && echo 'installed' || echo 'already present')"
echo "    GNU Stow:      $([ $installed_stow -eq 1 ] && echo 'installed' || echo 'already present')"
echo "    Removed links: ${#removed_links[@]}${removed_links:+ (${removed_links[*]})}"
echo "    Backed up:     ${#backed_up_dirs[@]}${backed_up_dirs:+ (${backed_up_dirs[*]})}"
echo "    Stowed:        ${#stowed_packages[@]} (${stowed_packages[*]})"
