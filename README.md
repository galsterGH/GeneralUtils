# GeneralUtils

Public repo with a sanitized `~/.zshrc` template.

- File: `.zshrc.example` (secrets redacted with placeholders like `<REDACTED:...>`).
- Helpers included: `grephelp`, `sedhelp`, `awkhelp`, `manh`, `cheat` (+ aliases).

## Installation

One-liner (download to home and run):

```bash
curl -fsSL https://raw.githubusercontent.com/galsterGH/GeneralUtils/main/install_zsh.sh \
  -o ~/install_zsh.sh && chmod +x ~/install_zsh.sh && ~/install_zsh.sh
```

One-liner (make zsh the default shell too):

```bash
curl -fsSL https://raw.githubusercontent.com/galsterGH/GeneralUtils/main/install_zsh.sh \
  -o ~/install_zsh.sh && chmod +x ~/install_zsh.sh && ~/install_zsh.sh --make-default
```

### macOS: Homebrew zsh

Use the Homebrew zsh as your login shell and install the template:

```bash
# Install zsh via Homebrew
brew install zsh

# Set Homebrew zsh as your default login shell
ZSH_PATH="$(brew --prefix)/bin/zsh"
grep -qx "$ZSH_PATH" /etc/shells || echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
chsh -s "$ZSH_PATH"

# Install sanitized ~/.zshrc from this repo
curl -fsSL https://raw.githubusercontent.com/galsterGH/GeneralUtils/main/install_zsh.sh \
  -o ~/install_zsh.sh && chmod +x ~/install_zsh.sh && ~/install_zsh.sh

# Switch now and verify
exec "$ZSH_PATH"
echo $SHELL
zsh --version
```

Notes:
- The `chsh` command may prompt for your password.
- `echo $SHELL` should print the same `ZSH_PATH` once you reopen your terminal or run `exec`.

Automated (recommended):

```bash
./install_zsh.sh            # installs zsh if needed; copies .zshrc.example to ~/.zshrc
./install_zsh.sh --make-default  # also sets zsh as your login shell
```

Manual:

```bash
cp .zshrc.example ~/.zshrc
exec zsh   # or start a new shell
```

## Keeping The Template In Sync

If your machine has the `Sync` helper (alias for `zshrc_sync`) in your `~/.zshrc`, you can update and publish the template from any shell:

```bash
# Sanitize secrets, update .zshrc.example, commit and push
Sync                 # defaults to ~/Projects/GeneralUtils

# Copy verbatim (may be blocked by GitHub push protection)
Sync --raw

# Target a different repo directory
Sync /path/to/GeneralUtils
```

Manual update (without the helper):

```bash
# In the repo root
cd ~/Projects/GeneralUtils

# Create/update the template (sanitize as needed)
cp ~/.zshrc .zshrc.example

# Commit and push
git add .zshrc.example
git commit -m "Update .zshrc.example"
git push
```

## VSCode C++ Environment Setup

The `setup-vscode-cpp.sh` script bootstraps a C++ project for use with Visual Studio Code.
Run it from the root of your project to generate a `.vscode` directory with tasks,
launch configurations, and recommended extensions. The script also creates a
`.clang-format` file and, for CMake projects, a `CMakePresets.json`.

Basic usage:

```bash
./setup-vscode-cpp.sh      # auto-detect build system and defaults
```

Common options:

```bash
./setup-vscode-cpp.sh --project-name MyApp      # custom project name
./setup-vscode-cpp.sh --namespace MyCompany::Util
./setup-vscode-cpp.sh --standard c++17          # choose C++ standard
./setup-vscode-cpp.sh --build-system cmake      # force build system
./setup-vscode-cpp.sh --force                   # overwrite existing config
```

Use `./setup-vscode-cpp.sh --help` to view all available flags.

## VSCode Go Environment Setup

The `setup-vscode-golang.sh` script bootstraps a Go project for use with Visual Studio Code.
Run it from the root of your project to generate a `.vscode` directory with tasks,
launch configurations, and recommended extensions. The script automatically detects and
installs Go if needed, sets up essential Go development tools, and creates a proper
Go module structure.

Basic usage:

```bash
./setup-vscode-golang.sh      # auto-detect everything
```

Common options:

```bash
./setup-vscode-golang.sh --project-name MyGoApp             # custom project name
./setup-vscode-golang.sh --module-name github.com/user/repo # Go module name
./setup-vscode-golang.sh --go-version 1.25                  # minimum Go version
./setup-vscode-golang.sh --force                            # overwrite existing config
./setup-vscode-golang.sh --install-go                       # force Go installation
```

The script will:
- Check for Go installation and install if missing (supports macOS/Linux auto-install)
- Install essential Go tools: `gopls`, `dlv`, `goimports`, and more
- Create VSCode configuration optimized for Go development
- Initialize a Go module if one doesn't exist
- Set up project structure with `cmd/`, `pkg/`, and `internal/` directories
- Generate sample `main.go` and `.gitignore` files

Use `./setup-vscode-golang.sh --help` to view all available flags.

