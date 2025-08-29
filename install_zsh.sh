#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./install_zsh.sh [--make-default]

Installs zsh (if missing), then copies .zshrc.example from this repo
into your home directory as ~/.zshrc (backing up any existing file).

Options:
  --make-default  Also set zsh as your login shell (uses chsh; may prompt).

Notes:
  - On macOS, zsh is usually preinstalled. Homebrew fallback is used if not.
  - On Linux, attempts apt/dnf/pacman/zypper with sudo.
USAGE
}

MAKE_DEFAULT=false
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage; exit 0
elif [[ "${1:-}" == "--make-default" ]]; then
  MAKE_DEFAULT=true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_EXAMPLE="$SCRIPT_DIR/.zshrc.example"
DEST="$HOME/.zshrc"

if [[ ! -f "$SRC_EXAMPLE" ]]; then
  echo "Error: $SRC_EXAMPLE not found. Run this from the repo with .zshrc.example present." >&2
  exit 1
fi

have_cmd() { command -v "$1" >/dev/null 2>&1; }

install_zsh() {
  if have_cmd zsh; then
    echo "zsh already installed: $(command -v zsh)"
    return 0
  fi

  echo "zsh not found; attempting installation..."
  UNAME=$(uname -s 2>/dev/null || echo unknown)
  case "$UNAME" in
    Darwin)
      if have_cmd brew; then
        brew install zsh
      else
        echo "Homebrew not found. Install Homebrew from https://brew.sh then re-run." >&2
        exit 1
      fi
      ;;
    Linux)
      if have_cmd apt-get; then
        sudo apt-get update && sudo apt-get install -y zsh
      elif have_cmd dnf; then
        sudo dnf install -y zsh
      elif have_cmd yum; then
        sudo yum install -y zsh
      elif have_cmd pacman; then
        sudo pacman -Sy --noconfirm zsh
      elif have_cmd zypper; then
        sudo zypper install -y zsh
      else
        echo "No supported package manager found. Install zsh manually." >&2
        exit 1
      fi
      ;;
    *)
      echo "Unsupported OS: $UNAME. Please install zsh manually." >&2
      exit 1
      ;;
  esac

  echo "Installed zsh: $(command -v zsh || true)"
}

set_default_shell_if_requested() {
  if [[ "$MAKE_DEFAULT" != true ]]; then
    return 0
  fi
  local zsh_path
  zsh_path="$(command -v zsh || true)"
  if [[ -z "$zsh_path" ]]; then
    echo "Cannot set default shell: zsh not found in PATH" >&2
    return 1
  fi

  # Ensure zsh is listed in /etc/shells (required on many systems)
  if [[ -w /etc/shells ]]; then
    grep -qx "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  else
    grep -qx "$zsh_path" /etc/shells 2>/dev/null || echo "Note: $zsh_path not in /etc/shells; attempting to add with sudo..." >&2
    grep -qx "$zsh_path" /etc/shells 2>/dev/null || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null || true
  fi

  echo "Changing default shell to: $zsh_path"
  chsh -s "$zsh_path" || {
    echo "Failed to change shell with chsh. You may need to run: chsh -s $zsh_path" >&2
  }
}

backup_and_copy() {
  if [[ -f "$DEST" ]]; then
    local ts
    ts=$(date +%Y%m%d%H%M%S)
    local backup="$DEST.bak.$ts"
    cp -f "$DEST" "$backup"
    echo "Backed up existing ~/.zshrc to $backup"
  fi
  cp -f "$SRC_EXAMPLE" "$DEST"
  echo "Copied $SRC_EXAMPLE -> $DEST"
}

install_zsh
backup_and_copy
set_default_shell_if_requested

echo "Done. Launch zsh or run: exec zsh"
if [[ "$MAKE_DEFAULT" != true ]]; then
  echo "Tip: Re-run with --make-default to set zsh as your login shell."
fi

