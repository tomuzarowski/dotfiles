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
installed_jq=0
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

if ! command -v jq &>/dev/null; then
  info "Installing jq..."
  brew install jq
  installed_jq=1
fi

# Strip the machine-specific autoMode block from Claude Code settings on commit,
# and sort keys because Claude Code reorders them when it saves settings
git -C "$DOTFILES_DIR" config filter.claude-settings.clean "jq -S 'del(.autoMode)'"
git -C "$DOTFILES_DIR" config filter.claude-settings.smudge cat
git -C "$DOTFILES_DIR" config filter.claude-settings.required true

# Pi creates a machine-specific OpenAI OAuth installation ID in settings.
git -C "$DOTFILES_DIR" config filter.pi-settings.clean "jq -S 'del(.deviceId)'"
git -C "$DOTFILES_DIR" config filter.pi-settings.smudge cat
git -C "$DOTFILES_DIR" config filter.pi-settings.required true

# Pi writes credentials, packages and sessions beside its configuration.
# Keep these directories real so Stow never sends runtime data into dotfiles.
if [ -d "$DOTFILES_DIR/home/.pi" ]; then
  for rel in .pi .pi/agent .pi/agent/extensions .pi/agent/skills; do
    target="$HOME/$rel"
    if [ -L "$target" ]; then
      if [ -e "$target" ]; then
        warn "Pi directory is already a symlink: $target. Migrate its contents to a real directory before installing."
        exit 1
      fi
      backup="$target.backup-$(date +%Y%m%d%H%M%S)"
      warn "Backing up dangling symlink: $target -> $backup"
      mv "$target" "$backup"
      backed_up_dirs+=("$rel")
    fi
    mkdir -p "$target"
  done
  for path in "$DOTFILES_DIR"/home/.pi/agent/* "$DOTFILES_DIR"/home/.pi/agent/extensions/* "$DOTFILES_DIR"/home/.pi/agent/skills/*; do
    [ -e "$path" ] || continue
    rel=${path#"$DOTFILES_DIR/home/"}
    case "$rel" in .pi/agent/extensions|.pi/agent/skills) continue ;; esac
    target="$HOME/$rel"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      backup="$target.backup-$(date +%Y%m%d%H%M%S)"
      warn "Backing up existing Pi configuration: $target -> $backup"
      mv "$target" "$backup"
      backed_up_dirs+=("$rel")
    fi
  done
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

# Keep ~/.claude and its skills directory real so Stow links individual entries,
# and back up files Claude Code created before the first install
if [ -d "$DOTFILES_DIR/home/.claude" ]; then
  mkdir -p "$HOME/.claude/skills"
  for path in "$DOTFILES_DIR"/home/.claude/* "$DOTFILES_DIR"/home/.claude/skills/*; do
    [ -e "$path" ] || continue
    rel=${path#"$DOTFILES_DIR/home/"}
    [ "$rel" = ".claude/skills" ] && continue
    target="$HOME/$rel"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      backup="$target.backup-$(date +%Y%m%d%H%M%S)"
      warn "Backing up existing file: $target -> $backup"
      mv "$target" "$backup"
      backed_up_dirs+=("$rel")
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

echo
success "Done!"
echo "    Homebrew:      $([ $installed_brew -eq 1 ] && echo 'installed' || echo 'already present')"
echo "    GNU Stow:      $([ $installed_stow -eq 1 ] && echo 'installed' || echo 'already present')"
echo "    jq:            $([ $installed_jq -eq 1 ] && echo 'installed' || echo 'already present')"
echo "    Removed links: ${#removed_links[@]}${removed_links:+ (${removed_links[*]})}"
echo "    Backed up:     ${#backed_up_dirs[@]}${backed_up_dirs:+ (${backed_up_dirs[*]})}"
echo "    Stowed:        ${#stowed_packages[@]} (${stowed_packages[*]})"
