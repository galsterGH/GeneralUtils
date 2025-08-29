# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

export LSCOLORS=GxFxCxDxBxegedabagaced


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
 DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
 DISABLE_LS_COLORS="true"
 

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew branch command-not-found fzf history iterm2 rsync rust vscode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable fzf key bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Optional: Enable fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable mouse support
set -g mouse on

# Set default terminal mode
set -g default-terminal "screen-256color"

# Enable 256 color support
set -ga terminal-overrides ",xterm-256color:Tc"

export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="--sort --exact"

function chatgpt() {
  local prompt="$1"
  curl -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <REDACTED>" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [{"role": "user", "content": "'"$prompt"'"}],
    "max_tokens": 150
  }'
}



[ -f "/Users/guyalster/.ghcup/env" ] && . "/Users/guyalster/.ghcup/env" # ghcup-env

# GHCup Environment
if [ -f "/Users/guyalster/.ghcup/env" ]; then
  source "/Users/guyalster/.ghcup/env"
fi  

alias tlc="java -cp ~/tla-tools/tla2tools.jar tlc2.TLC"
export PATH="$HOME/.ghcup/bin/haskell-language-server-9.10.1:/opt/homebrew/Cellar/llvm@13/13.0.1_2/bin:/opt/homebrew/opt/openjdk/bin  :$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# Created by `pipx` on 2025-03-12 05:05:09
export PATH="$PATH:/Users/guyalster/.local/bin"
# Custom Aliases
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -lah"
alias md="mkdir -p"
alias rd="rmdir"
alias c="clear"
alias h="history -10"
alias hg="history | grep"

# Git
alias gs="git status"
alias gd="git diff"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gcm="git checkout main"
alias gcb="git checkout -b"
alias glog="git log --oneline --decorate --graph"
alias back="git checkout @{-1}"
squash() { git reset --soft $1; git commit -a --amend --no-edit; }  # Squash commits to a given hash

# Package Management (npm/Yarn)
alias ni="npm install"
alias nis="npm install --save"
alias nid="npm install --save-dev"
alias nrs="npm run start"
alias nrt="npm run test"
alias y="yarn"
alias yolo="rm -rf node_modules/ package-lock.json && yarn install"

# Docker
alias dps="docker ps"
alias dpa="docker ps -a"
dlogs() { docker logs $1; }
drmf() { docker rm -f $(docker ps -a -q); }

# Utilities
alias myip="curl http://ipecho.net/plain; echo"
alias reload="source ~/.zshrc"
alias oz="code ~/.zshrc"  # Assumes VS Code
alias ffs="sudo !!"  # Rerun last command with sudo

alias la="alias | grep -v 'oh-my-zsh' && cat ~/.zshrc | grep '^alias'"export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# --- BEGIN: grephelp function (Codex CLI) ---
grephelp() {
  cat <<'HLP'
\033[1;36mGREP QUICK HELP\033[0m

\033[1mBasic Syntax\033[0m
  grep [OPTIONS] PATTERN [FILE...]
  - By default PATTERN is a Basic Regular Expression (BRE)
  - Use -E for Extended regex, -F for fixed strings, -P for PCRE (if available)

\033[1mMost Useful Options\033[0m
  -i  Ignore case                    -n  Show line numbers
  -r  Recurse subdirs                -R  Recurse and follow symlinks
  -H  Show filenames                 -h  Hide filenames
  -c  Count matches per file         -l  List files with matches
  -L  List files without matches     -v  Invert match
  -w  Match whole words              -x  Match whole lines
  -o  Print only the match           -m N  Stop after N matches
  -A N  N lines After match          -B N  N lines Before match
  -C N  N lines of Context           --color=auto  Highlight matches
  --include='*.ext'  Only these files    --exclude='*.min.js'  Skip files
  --exclude-dir=dir  Skip directories     -s  Suppress error messages
  -a  Treat binary as text           -I  Ignore binary files

\033[1mRegex Notes\033[0m
  ^ start of line    $ end of line    . any char    .* any chars
  [...] character class      [^...] negated class    \b word boundary (PCRE)
  Use single quotes around patterns to avoid shell expansion.

\033[1mCommon Examples\033[0m
  1) Simple search in file
     grep "needle" file.txt

  2) Case-insensitive search in logs
     grep -i "error" /var/log/system.log

  3) Recursive search in a codebase
     grep -Rn "TODO" src/

  4) Recursive, include only JS/TS, exclude minified
     grep -R --include='*.{js,ts}' --exclude='*.min.js' "fetch\(" src/

  5) Show context around matches (2 lines each side)
     grep -nC2 "failed" app.log

  6) List only filenames that contain a match
     grep -Rl "main(" .

  7) Count matches per file in tree
     grep -Rc "TODO" .

  8) Whole word / whole line matches
     grep -Rw "init" src/        # word
     grep -Rx "^USE_STRICT$" src/ # whole line (exact)

  9) Extended regex OR
     grep -E "foo|bar" file.txt

 10) Fixed string (no regex), useful for special chars
     grep -F "a+b(c)" notes.txt

 11) Lines starting with or ending with
     grep "^ERROR" app.log
     grep ";$"    script.sql

 12) Multiple patterns (extended)
     grep -RE "(error|fail|panic)" .

 13) Exclude directories (e.g., .git and dist)
     grep -R --exclude-dir={.git,dist} "pattern" .

 14) Searching command output; avoid matching the grep itself
     ps aux | grep -i "[n]ode"

\033[1mTips\033[0m
  - Use -E for readable alternations and quantifiers.
  - Quote patterns: single quotes prevent the shell from expanding regex.
  - Prefer -R over -r when you want to follow symlinks.
  - For big repos, combine --include/--exclude to limit scope.
  - For full docs: run "grep --help" or "man grep".
HLP
}
# --- END: grephelp function (Codex CLI) ---


# --- BEGIN: grephelp alias (Codex CLI) ---
alias gh='grephelp'
# --- END: grephelp alias (Codex CLI) ---


# --- BEGIN: sedhelp function (Codex CLI) ---
sedhelp() {
  cat <<'HLP'
\033[1;36mSED QUICK HELP\033[0m

\033[1mBasic Syntax\033[0m
  sed [OPTIONS] 'SCRIPT' [FILE...]
  - Streams input line by line; applies SCRIPT; prints result.
  - Without -n, sed prints every processed line. Use -n to suppress.

\033[1mKey Options\033[0m
  -n    Suppress auto-print; use p to print
  -E    Use Extended regex (ERE)
  -e    Add another script segment
  -f F  Read script from file F
  -i    In-place edit (see notes below)

\033[1mIn-place Editing\033[0m
  - macOS/BSD:  sed -i '' 's/old/new/g' file.txt   # no backup
                 sed -i '.bak' 's/old/new/g' file.txt
  - GNU/Linux:  sed -i 's/old/new/g' file.txt      # no backup
                 sed -i.bak 's/old/new/g' file.txt

\033[1mCommon Examples\033[0m
  1) Print only matching lines (like grep)
     sed -n '/ERROR/p' app.log

  2) Delete lines matching a pattern
     sed '/^#/d' config.ini

  3) Replace first occurrence on each line
     sed 's/foo/bar/' file.txt

  4) Replace all occurrences on each line
     sed 's/foo/bar/g' file.txt

  5) Use Extended regex (groups, +, ?)
     sed -E 's/(foo)+/bar/g' file.txt

  6) Replace in-place with backup
     sed -i.bak 's/localhost/127.0.0.1/g' hosts

  7) Print a line range
     sed -n '10,20p' file.txt

  8) Print from pattern A to B
     sed -n '/BEGIN/,/END/p' file.txt

  9) Insert/Append lines around a match
     sed '/pattern/i\
Inserted before\
' file.txt
     sed '/pattern/a\
Appended after\
' file.txt

 10) Remove blank lines (or trim)
     sed '/^$/d' file.txt
     sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' file.txt

 11) Edit only lines that match (addressed command)
     sed '/^Title:/ s/Untitled/Report/' notes.md

 12) Replace across multiple files safely
     grep -Rl 'old' src | xargs sed -i.bak 's/old/new/g'

\033[1mAddress/Command Basics\033[0m
  [addr]command
  - Address can be a line number (10), a range (10,20), or a regex (/foo/)
  - Common commands: s (substitute), d (delete), p (print), i (insert), a (append)

\033[1mTips\033[0m
  - Quote with single quotes to prevent shell expansion.
  - Test without -i first to verify output.
  - Use -E for clearer regex; use POSIX classes like [[:digit:]] [[:space:]].
  - For complex edits, put commands in a script file and use -f.
HLP
}
# --- END: sedhelp function (Codex CLI) ---


# --- BEGIN: awkhelp function (Codex CLI) ---
awkhelp() {
  cat <<'HLP'
\033[1;36mawk QUICK HELP\033[0m

\033[1mBasic Syntax\033[0m
  awk 'PROGRAM' [FILE...]
  - Processes input record by record (default: line). Fields are $1..$NF.
  - Pattern { action } pairs run when pattern matches; omit pattern to run always.

\033[1mKey Concepts\033[0m
  - FS: input field separator (default: spaces)   use -F ',' or BEGIN{FS=","}
  - OFS: output field separator (default: space)
  - NR: current record number      NF: number of fields
  - BEGIN { ... } runs before input; END { ... } runs after input

\033[1mCommon Examples\033[0m
  1) Print specific columns
     awk '{print $1, $3}' file.txt

  2) CSV column with -F
     awk -F, '{print $2}' data.csv

  3) Filter rows by regex or numeric test
     awk '/ERROR/' app.log
     awk '$3 > 100' data.txt

  4) Sum a column; print total
     awk '{sum += $3} END {print sum}' data.txt

  5) Average of a column
     awk '{s += $2; n++} END {if (n) print s/n}' data.txt

  6) Add header/footer with BEGIN/END
     awk 'BEGIN{print "user,count"} {c[$1]++} END{for (u in c) print u "," c[u]}' users.txt

  7) Group by key and sum values
     awk '{sum[$1] += $2} END {for (k in sum) print k, sum[k]}' pairs.txt

  8) Unique by first field (keep first occurrence)
     awk '!seen[$1]++' file.txt

  9) Reformat with OFS and printf
     awk 'BEGIN{OFS=","} {print $1,$2,$3}' data.txt
     awk '{printf "%s -> %.2f\n", $1, $2}' data.txt

 10) Change delimiter and lowercase a column
     awk 'BEGIN{FS=OFS=","} { $1=tolower($1); print }' data.csv

 11) Pass a shell variable into awk
     thresh=90; awk -v t="$thresh" '$2>t' scores.txt

 12) Compute frequency of words (simple)
     tr -s ' ' '\n' < text | awk 'NF{count[$1]++} END{for (w in count) print count[w], w}' | sort -nr

\033[1mTips\033[0m
  - Use single quotes around the program; escape inner quotes as needed.
  - Prefer -F for simple delimiters; use BEGIN{FS=...} for more complex cases.
  - Arrays are associative; iterate with for (k in arr).
  - Set OFS to control output separators.
HLP
}
# --- END: awkhelp function (Codex CLI) ---

# --- BEGIN: sedhelp alias (Codex CLI) ---
alias sedh='sedhelp'
# --- END: sedhelp alias (Codex CLI) ---

# --- BEGIN: awkhelp alias (Codex CLI) ---
alias awkh='awkhelp'
# --- END: awkhelp alias (Codex CLI) ---


# --- BEGIN: cheat wrapper (Codex CLI) ---
cheat() {
  local topic="${1:-}"
  case "$topic" in
    grep) grephelp ;;
    sed)  sedhelp  ;;
    awk)  awkhelp  ;;
    ""|-h|--help)
      echo "Usage: cheat {grep|sed|awk}"
      return 2 ;;
    *)
      echo "Unknown topic: $topic" >&2
      echo "Available: grep, sed, awk" >&2
      return 2 ;;
  esac
}

# Tab completion for cheat topics (zsh)
if typeset -f compdef >/dev/null 2>&1; then
  _cheat_topics() { compadd grep sed awk; }
  compdef _cheat_topics cheat
fi
# --- END: cheat wrapper (Codex CLI) ---


# --- BEGIN: cheat alias (Codex CLI) ---
alias ch='cheat'
# --- END: cheat alias (Codex CLI) ---


# --- BEGIN: manh function (Codex CLI) ---
manh() {
  cat <<'HLP'
\033[1;36mMAN + LESS QUICK HELP\033[0m

\033[1mBasics\033[0m
  man TOPIC                Show manual page (section auto-picked)
  man SECTION TOPIC        Specific section, e.g., man 3 printf
  apropos KEYWORD          Search descriptions (same as: man -k KEYWORD)

\033[1mCommon Sections\033[0m
  1: user cmds   2: syscalls   3: C libs
  4: devices     5: files      7: misc
  8: admin cmds

\033[1mFind Pages\033[0m
  man -k ssh               Search by keyword (apropos)
  man -f printf            One-line description (whatis)
  man -w tar               Print path to page

\033[1mOpen at Section\033[0m
  man 5 crontab            Open file-format page for crontab

\033[1mOpen At Match\033[0m
  man -P 'less -p ^SYNOPSIS' tar   Jump to SYNOPSIS (less searches '^SYNOPSIS')

\033[1mPager (less) Keys\033[0m
  q        Quit            h        Help inside less
  j/k      Down/Up line    g/G      Start/End of page
  Space    Next page       b        Back page
  /pat     Search forward  ?pat     Search backward
  n / N    Next/Prev match &pat     Filter to matching lines
  { / }    Prev/Next paragraph      =   File info
  Ctrl-F/B Forward/Back page        Ctrl-G Status

\033[1mWrapping & Colors\033[0m
  export LESS='-R -S'      Preserve colors; cut long lines
  man --pager='less -R'    Force color-capable pager

\033[1mPractical Examples\033[0m
  man grep                 Read grep docs
  man 7 regex              Regex syntax reference
  man -k timer             Discover timer-related pages
  man -P 'less -p ^OPTIONS' rsync   Jump to OPTIONS section

\033[1mTips\033[0m
  - Use section numbers to disambiguate (e.g., 'printf' in 1 vs 3).
  - Inside less, 'u' half page up, 'd' half page down.
  - Use '&ERROR' to temporarily filter to matching lines, then '&' to clear.
HLP
}
# --- END: manh function (Codex CLI) ---

# --- BEGIN: manhelp alias (Codex CLI) ---
alias manhelp='manh'
# --- END: manhelp alias (Codex CLI) ---


# --- BEGIN: grephelp function (Codex CLI) v2 ---
unset -f grephelp 2>/dev/null || true
grephelp() {
  cat <<'HLP'
GREP QUICK HELP

Basic Syntax
  grep [OPTIONS] PATTERN [FILE...]
  - By default PATTERN is a Basic Regular Expression (BRE)
  - Use -E for Extended regex, -F for fixed strings, -P for PCRE (if available)

Most Useful Options
  -i  Ignore case                    -n  Show line numbers
  -r  Recurse subdirs                -R  Recurse and follow symlinks
  -H  Show filenames                 -h  Hide filenames
  -c  Count matches per file         -l  List files with matches
  -L  List files without matches     -v  Invert match
  -w  Match whole words              -x  Match whole lines
  -o  Print only the match           -m N  Stop after N matches
  -A N  N lines After match          -B N  N lines Before match
  -C N  N lines of Context           --color=auto  Highlight matches
  --include='*.ext'  Only these files    --exclude='*.min.js'  Skip files
  --exclude-dir=dir  Skip directories     -s  Suppress error messages
  -a  Treat binary as text           -I  Ignore binary files

Regex Notes
  ^ start of line    $ end of line    . any char    .* any chars
  [...] character class      [^...] negated class    \b word boundary (PCRE)
  Use single quotes around patterns to avoid shell expansion.

Common Examples
  1) Simple search in file
     grep "needle" file.txt

  2) Case-insensitive search in logs
     grep -i "error" /var/log/system.log

  3) Recursive search in a codebase
     grep -Rn "TODO" src/

  4) Recursive, include only JS/TS, exclude minified
     grep -R --include='*.{js,ts}' --exclude='*.min.js' "fetch\(" src/

  5) Show context around matches (2 lines each side)
     grep -nC2 "failed" app.log

  6) List only filenames that contain a match
     grep -Rl "main(" .

  7) Count matches per file in tree
     grep -Rc "TODO" .

  8) Whole word / whole line matches
     grep -Rw "init" src/        # word
     grep -Rx "^USE_STRICT$" src/ # whole line (exact)

  9) Extended regex OR
     grep -E "foo|bar" file.txt

 10) Fixed string (no regex), useful for special chars
     grep -F "a+b(c)" notes.txt

 11) Lines starting with or ending with
     grep "^ERROR" app.log
     grep ";$"    script.sql

 12) Multiple patterns (extended)
     grep -RE "(error|fail|panic)" .

 13) Exclude directories (e.g., .git and dist)
     grep -R --exclude-dir={.git,dist} "pattern" .

 14) Searching command output; avoid matching the grep itself
     ps aux | grep -i "[n]ode"

Tips
  - Use -E for readable alternations and quantifiers.
  - Quote patterns: single quotes prevent the shell from expanding regex.
  - Prefer -R over -r when you want to follow symlinks.
  - For big repos, combine --include/--exclude to limit scope.
  - For full docs: run "grep --help" or "man grep".
HLP
}
# --- END: grephelp function (Codex CLI) v2 ---

# --- BEGIN: sedhelp function (Codex CLI) v2 ---
unset -f sedhelp 2>/dev/null || true
sedhelp() {
  cat <<'HLP'
SED QUICK HELP

Basic Syntax
  sed [OPTIONS] 'SCRIPT' [FILE...]
  - Streams input line by line; applies SCRIPT; prints result.
  - Without -n, sed prints every processed line. Use -n to suppress.

Key Options
  -n    Suppress auto-print; use p to print
  -E    Use Extended regex (ERE)
  -e    Add another script segment
  -f F  Read script from file F
  -i    In-place edit (see notes below)

In-place Editing
  - macOS/BSD:  sed -i '' 's/old/new/g' file.txt   # no backup
                 sed -i '.bak' 's/old/new/g' file.txt
  - GNU/Linux:  sed -i 's/old/new/g' file.txt      # no backup
                 sed -i.bak 's/old/new/g' file.txt

Common Examples
  1) Print only matching lines (like grep)
     sed -n '/ERROR/p' app.log

  2) Delete lines matching a pattern
     sed '/^#/d' config.ini

  3) Replace first occurrence on each line
     sed 's/foo/bar/' file.txt

  4) Replace all occurrences on each line
     sed 's/foo/bar/g' file.txt

  5) Use Extended regex (groups, +, ?)
     sed -E 's/(foo)+/bar/g' file.txt

  6) Replace in-place with backup
     sed -i.bak 's/localhost/127.0.0.1/g' hosts

  7) Print a line range
     sed -n '10,20p' file.txt

  8) Print from pattern A to B
     sed -n '/BEGIN/,/END/p' file.txt

  9) Insert/Append lines around a match
     sed '/pattern/i\
Inserted before\
' file.txt
     sed '/pattern/a\
Appended after\
' file.txt

 10) Remove blank lines (or trim)
     sed '/^$/d' file.txt
     sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' file.txt

 11) Edit only lines that match (addressed command)
     sed '/^Title:/ s/Untitled/Report/' notes.md

 12) Replace across multiple files safely
     grep -Rl 'old' src | xargs sed -i.bak 's/old/new/g'

Address/Command Basics
  [addr]command
  - Address can be a line number (10), a range (10,20), or a regex (/foo/)
  - Common commands: s (substitute), d (delete), p (print), i (insert), a (append)

Tips
  - Quote with single quotes to prevent shell expansion.
  - Test without -i first to verify output.
  - Use -E for clearer regex; use POSIX classes like [[:digit:]] [[:space:]].
  - For complex edits, put commands in a script file and use -f.
HLP
}
# --- END: sedhelp function (Codex CLI) v2 ---

# --- BEGIN: awkhelp function (Codex CLI) v2 ---
unset -f awkhelp 2>/dev/null || true
awkhelp() {
  cat <<'HLP'
awk QUICK HELP

Basic Syntax
  awk 'PROGRAM' [FILE...]
  - Processes input record by record (default: line). Fields are $1..$NF.
  - Pattern { action } pairs run when pattern matches; omit pattern to run always.

Key Concepts
  - FS: input field separator (default: spaces)   use -F ',' or BEGIN{FS=","}
  - OFS: output field separator (default: space)
  - NR: current record number      NF: number of fields
  - BEGIN { ... } runs before input; END { ... } runs after input

Common Examples
  1) Print specific columns
     awk '{print $1, $3}' file.txt

  2) CSV column with -F
     awk -F, '{print $2}' data.csv

  3) Filter rows by regex or numeric test
     awk '/ERROR/' app.log
     awk '$3 > 100' data.txt

  4) Sum a column; print total
     awk '{sum += $3} END {print sum}' data.txt

  5) Average of a column
     awk '{s += $2; n++} END {if (n) print s/n}' data.txt

  6) Add header/footer with BEGIN/END
     awk 'BEGIN{print "user,count"} {c[$1]++} END{for (u in c) print u "," c[u]}' users.txt

  7) Group by key and sum values
     awk '{sum[$1] += $2} END {for (k in sum) print k, sum[k]}' pairs.txt

  8) Unique by first field (keep first occurrence)
     awk '!seen[$1]++' file.txt

  9) Reformat with OFS and printf
     awk 'BEGIN{OFS=","} {print $1,$2,$3}' data.txt
     awk '{printf "%s -> %.2f\n", $1, $2}' data.txt

 10) Change delimiter and lowercase a column
     awk 'BEGIN{FS=OFS=","} { $1=tolower($1); print }' data.csv

 11) Pass a shell variable into awk
     thresh=90; awk -v t="$thresh" '$2>t' scores.txt

 12) Compute frequency of words (simple)
     tr -s ' ' '\n' < text | awk 'NF{count[$1]++} END{for (w in count) print count[w], w}' | sort -nr

Tips
  - Use single quotes around the program; escape inner quotes as needed.
  - Prefer -F for simple delimiters; use BEGIN{FS=...} for more complex cases.
  - Arrays are associative; iterate with for (k in arr).
  - Set OFS to control output separators.
HLP
}
# --- END: awkhelp function (Codex CLI) v2 ---

# --- BEGIN: manh function (Codex CLI) v2 ---
unset -f manh 2>/dev/null || true
manh() {
  cat <<'HLP'
MAN + LESS QUICK HELP

Basics
  man TOPIC                Show manual page (section auto-picked)
  man SECTION TOPIC        Specific section, e.g., man 3 printf
  apropos KEYWORD          Search descriptions (same as: man -k KEYWORD)

Common Sections
  1: user cmds   2: syscalls   3: C libs
  4: devices     5: files      7: misc
  8: admin cmds

Find Pages
  man -k ssh               Search by keyword (apropos)
  man -f printf            One-line description (whatis)
  man -w tar               Print path to page

Open at Section
  man 5 crontab            Open file-format page for crontab

Open At Match
  man -P 'less -p ^SYNOPSIS' tar   Jump to SYNOPSIS (less searches '^SYNOPSIS')

Pager (less) Keys
  q        Quit            h        Help inside less
  j/k      Down/Up line    g/G      Start/End of page
  Space    Next page       b        Back page
  /pat     Search forward  ?pat     Search backward
  n / N    Next/Prev match &pat     Filter to matching lines
  { / }    Prev/Next paragraph      =   File info
  Ctrl-F/B Forward/Back page        Ctrl-G Status

Wrapping & Colors
  export LESS='-R -S'      Preserve colors; cut long lines
  man --pager='less -R'    Force color-capable pager

Practical Examples
  man grep                 Read grep docs
  man 7 regex              Regex syntax reference
  man -k timer             Discover timer-related pages
  man -P 'less -p ^OPTIONS' rsync   Jump to OPTIONS section

Tips
  - Use section numbers to disambiguate (e.g., 'printf' in 1 vs 3).
  - Inside less, 'u' half page up, 'd' half page down.
  - Use '&ERROR' to temporarily filter to matching lines, then '&' to clear.
HLP
}
# --- END: manh function (Codex CLI) v2 ---

