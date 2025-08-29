#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: ./install_zsh.sh [--make-default] [--example-url URL]

Installs zsh (if missing), then copies a sanitized .zshrc template
into your home directory as ~/.zshrc (backing up any existing file).
By default, it looks for .zshrc.example next to this script; if not found,
it fetches it from GitHub unless --example-url is provided.

Options:
  --make-default       Also set zsh as your login shell (uses chsh; may prompt).
  --example-url URL    Download template from URL when local .zshrc.example is missing.

Notes:
  - On macOS, zsh is usually preinstalled. Homebrew fallback is used if not.
  - On Linux, attempts apt/dnf/pacman/zypper with sudo.
USAGE
}

MAKE_DEFAULT=false
EXAMPLE_URL=""
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage; exit 0
elif [[ "${1:-}" == "--make-default" ]]; then
  MAKE_DEFAULT=true; shift
fi

if [[ "${1:-}" == "--example-url" ]]; then
  shift; EXAMPLE_URL="${1:-}"
  shift || true
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.zshrc"

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

fetch_cmd() {
  if command -v curl >/dev/null 2>&1; then
    echo "curl -fsSL"
  elif command -v wget >/dev/null 2>&1; then
    echo "wget -qO-"
  else
    return 1
  fi
}

resolve_template_source() {
  # Sets GLOBAL: SRC_EXAMPLE and optionally TMP_EXAMPLE when downloaded
  SRC_EXAMPLE=""
  TMP_EXAMPLE=""
  local local_example="$SCRIPT_DIR/.zshrc.example"
  if [[ -f "$local_example" ]]; then
    SRC_EXAMPLE="$local_example"
    return 0
  fi
  # Prefer provided URL, else default to repo URL
  local url="$EXAMPLE_URL"
  if [[ -z "$url" ]]; then
    url="https://raw.githubusercontent.com/galsterGH/GeneralUtils/main/.zshrc.example"
  fi
  local fetch
  if ! fetch=$(fetch_cmd); then
    echo "Error: .zshrc.example not found locally and neither curl nor wget available to fetch from $url" >&2
    return 1
  fi
  TMP_EXAMPLE="$(mktemp)"
  echo "Fetching template from: $url"
  # shellcheck disable=SC2086
  $fetch "$url" > "$TMP_EXAMPLE"
  if [[ ! -s "$TMP_EXAMPLE" ]]; then
    echo "Error: failed to download template from $url" >&2
    return 1
  fi
  SRC_EXAMPLE="$TMP_EXAMPLE"
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
resolve_template_source
backup_and_copy
set_default_shell_if_requested

echo "Done. Launch zsh or run: exec zsh"
if [[ "$MAKE_DEFAULT" != true ]]; then
  echo "Tip: Re-run with --make-default to set zsh as your login shell."
fi
