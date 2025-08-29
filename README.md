# GeneralUtils

Public repo with a sanitized `~/.zshrc` template.

- File: `.zshrc.example` (secrets redacted with placeholders like `<REDACTED:...>`).
- Helpers included: `grephelp`, `sedhelp`, `awkhelp`, `manh`, `cheat` (+ aliases).

## Installation

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
