#!/bin/bash

# VSCode Go Environment Setup Script
# Automatically configures VSCode for Go development with IntelliSense, build tasks, and debugging

set -e  # Exit on error

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/vscode-templates"
PROJECT_ROOT="$(pwd)"
VSCODE_DIR="$PROJECT_ROOT/.vscode"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Print usage information
print_usage() {
    cat << EOF
Usage: $0 [options]

Options:
    -h, --help              Show this help message
    -p, --project-name NAME Set project name (default: current directory name)
    -m, --module-name NAME  Set Go module name (default: project name)
    -v, --go-version VER    Set minimum Go version (default: 1.24.7)
    -f, --force             Force overwrite existing VSCode configuration
    --install-go            Force installation of Go even if already present

Examples:
    $0                                      # Auto-detect everything
    $0 --project-name MyGoProject           # Set specific project name
    $0 --module-name github.com/user/proj   # Set Go module name
    $0 --go-version 1.22                    # Set minimum Go version

EOF
}

# Parse command line arguments
parse_args() {
    PROJECT_NAME=$(basename "$PROJECT_ROOT")
    MODULE_NAME="$PROJECT_NAME"
    GO_VERSION="1.24.7"
    FORCE_OVERWRITE=false
    INSTALL_GO=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                print_usage
                exit 0
                ;;
            -p|--project-name)
                PROJECT_NAME="$2"
                shift 2
                ;;
            -m|--module-name)
                MODULE_NAME="$2"
                shift 2
                ;;
            -v|--go-version)
                GO_VERSION="$2"
                shift 2
                ;;
            -f|--force)
                FORCE_OVERWRITE=true
                shift
                ;;
            --install-go)
                INSTALL_GO=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done
}

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            OS="macos"
            ARCH=$(uname -m)
            log_info "Detected macOS ($ARCH)"
            ;;
        Linux*)
            OS="linux"
            ARCH=$(uname -m)
            log_info "Detected Linux ($ARCH)"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            OS="windows"
            ARCH="amd64"
            log_info "Detected Windows"
            ;;
        *)
            log_error "Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac
}

# Check if Go is installed and get version
check_go_installation() {
    if command -v go &> /dev/null; then
        GO_PATH=$(which go)
        INSTALLED_VERSION=$(go version | cut -d' ' -f3 | sed 's/go//')
        log_info "Found Go $INSTALLED_VERSION at $GO_PATH"

        # Convert versions to comparable format
        INSTALLED_VER_NUM=$(echo "$INSTALLED_VERSION" | sed 's/\([0-9]*\)\.\([0-9]*\).*/\1\2/' | sed 's/^0*//')
        REQUIRED_VER_NUM=$(echo "$GO_VERSION" | sed 's/\([0-9]*\)\.\([0-9]*\).*/\1\2/' | sed 's/^0*//')

        if [[ $INSTALLED_VER_NUM -lt $REQUIRED_VER_NUM ]]; then
            log_warn "Go version $INSTALLED_VERSION is older than required $GO_VERSION"
            if [[ "$INSTALL_GO" == false ]]; then
                echo -n "Do you want to install a newer version? [y/N]: "
                read -r response
                if [[ "$response" =~ ^[Yy]$ ]]; then
                    INSTALL_GO=true
                fi
            fi
        else
            GO_INSTALLED=true
            log_success "Go version meets requirements"
        fi
    else
        log_warn "Go is not installed"
        INSTALL_GO=true
        GO_INSTALLED=false
    fi
}

# Install Go
install_go() {
    log_info "Installing Go $GO_VERSION..."

    # Map architecture names
    case "$ARCH" in
        x86_64|amd64)
            GO_ARCH="amd64"
            ;;
        arm64|aarch64)
            GO_ARCH="arm64"
            ;;
        *)
            log_error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    # Determine download URL
    case "$OS" in
        macos)
            GO_OS="darwin"
            GO_FILE="go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz"
            ;;
        linux)
            GO_OS="linux"
            GO_FILE="go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz"
            ;;
        windows)
            GO_OS="windows"
            GO_FILE="go${GO_VERSION}.${GO_OS}-${GO_ARCH}.zip"
            ;;
    esac

    GO_URL="https://golang.org/dl/${GO_FILE}"
    TEMP_DIR=$(mktemp -d)

    log_info "Downloading Go from $GO_URL"

    if command -v curl &> /dev/null; then
        curl -L -o "${TEMP_DIR}/${GO_FILE}" "$GO_URL"
    elif command -v wget &> /dev/null; then
        wget -O "${TEMP_DIR}/${GO_FILE}" "$GO_URL"
    else
        log_error "Neither curl nor wget is available for downloading Go"
        exit 1
    fi

    # Install Go
    case "$OS" in
        macos|linux)
            # Install to user's home directory to avoid sudo
            GO_INSTALL_DIR="$HOME/go-installation"

            # Remove existing Go installation if it exists
            rm -rf "$GO_INSTALL_DIR"

            # Extract new Go installation
            cd "$TEMP_DIR"
            tar -xzf "$GO_FILE"
            mkdir -p "$GO_INSTALL_DIR"
            mv go "$GO_INSTALL_DIR/"

            # Add to PATH if not already there
            GO_BIN_PATH="$GO_INSTALL_DIR/go/bin"
            if ! echo "$PATH" | grep -q "$GO_BIN_PATH"; then
                log_info "Adding Go to PATH in shell profile"

                # Determine shell profile file
                if [[ "$SHELL" == *"zsh"* ]]; then
                    PROFILE_FILE="$HOME/.zshrc"
                elif [[ "$SHELL" == *"bash"* ]]; then
                    PROFILE_FILE="$HOME/.bashrc"
                else
                    PROFILE_FILE="$HOME/.profile"
                fi

                echo "export PATH=\"$GO_BIN_PATH:\$PATH\"" >> "$PROFILE_FILE"
                export PATH="$GO_BIN_PATH:$PATH"
                log_info "Added Go to PATH in $PROFILE_FILE"
            fi
            ;;
        windows)
            log_error "Automatic Go installation on Windows is not supported. Please install Go manually from https://golang.org/dl/"
            exit 1
            ;;
    esac

    # Clean up
    rm -rf "$TEMP_DIR"

    # Verify installation
    if command -v go &> /dev/null; then
        NEW_VERSION=$(go version | cut -d' ' -f3 | sed 's/go//')
        log_success "Go $NEW_VERSION installed successfully"
        GO_PATH=$(which go)
        GO_INSTALLED=true
    else
        log_error "Go installation failed"
        exit 1
    fi
}

# Check and install Go tools
check_go_tools() {
    log_info "Checking Go development tools..."

    # Essential tools list
    REQUIRED_TOOLS=(
        "golang.org/x/tools/gopls@latest"
        "github.com/go-delve/delve/cmd/dlv@latest"
        "golang.org/x/tools/cmd/goimports@latest"
        "github.com/fatih/gomodifytags@latest"
        "github.com/josharian/impl@latest"
        "github.com/ramya-rao-a/go-outline@latest"
        "golang.org/x/tools/cmd/guru@latest"
        "golang.org/x/tools/cmd/gorename@latest"
    )

    MISSING_TOOLS=()
    INSTALLED_COUNT=0
    FAILED_COUNT=0

    # Check which tools are missing
    for tool in "${REQUIRED_TOOLS[@]}"; do
        tool_name=$(echo "$tool" | sed 's|.*/||' | sed 's|@.*||')
        if ! command -v "$tool_name" &> /dev/null; then
            MISSING_TOOLS+=("$tool")
        fi
    done

    if [[ ${#MISSING_TOOLS[@]} -gt 0 ]]; then
        log_info "Installing missing Go tools (this may take a few minutes)..."

        # Set environment variables for better installation
        export GOPROXY=direct
        export GOSUMDB=off

        for tool in "${MISSING_TOOLS[@]}"; do
            log_info "Installing $tool"

            # Try to install with error handling
            if go install "$tool" 2>/dev/null; then
                ((INSTALLED_COUNT++))
            else
                log_warn "Failed to install $tool (compilation errors)"
                ((FAILED_COUNT++))
            fi
        done

        if [[ $INSTALLED_COUNT -gt 0 ]]; then
            log_success "$INSTALLED_COUNT Go tools installed successfully"
        fi

        if [[ $FAILED_COUNT -gt 0 ]]; then
            log_warn "$FAILED_COUNT tools failed to install due to compilation issues"
            log_warn "You can install them later with: go install <tool-name>"
            log_info "The VSCode Go extension can also auto-install missing tools when needed"
        fi
    else
        log_success "All Go tools are already installed"
    fi
}

# Initialize Go module if it doesn't exist
init_go_module() {
    if [[ ! -f "$PROJECT_ROOT/go.mod" ]]; then
        log_info "Initializing Go module: $MODULE_NAME"
        cd "$PROJECT_ROOT"
        if go mod init "$MODULE_NAME" 2>/dev/null; then
            log_success "Created go.mod file"
        else
            log_warn "Failed to create go.mod file, but continuing..."
        fi
    else
        log_info "Go module already exists"
    fi
}

# Check if VSCode config exists and handle overwrite
check_existing_config() {
    if [[ -d "$VSCODE_DIR" ]] && [[ "$FORCE_OVERWRITE" == false ]]; then
        log_warn "VSCode configuration already exists at $VSCODE_DIR"
        echo -n "Do you want to overwrite it? [y/N]: "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            log_info "Operation cancelled"
            exit 0
        fi
    fi
}

# Create VSCode directory
create_vscode_dir() {
    log_info "Creating .vscode directory..."
    mkdir -p "$VSCODE_DIR"
}

# Template substitution function
substitute_template() {
    local template_file="$1"
    local output_file="$2"

    if [[ ! -f "$template_file" ]]; then
        log_error "Template file not found: $template_file"
        return 1
    fi

    # Get Go version and path info
    GO_VERSION_FULL=$(go version | cut -d' ' -f3)
    GO_ROOT=$(dirname "$(dirname "$GO_PATH")")
    GO_BIN_PATH=$(dirname "$GO_PATH")
    GO_PATH_DIR="$HOME/go"

    # Perform variable substitution
    sed -e "s|{{OS_NAME}}|$OS|g" \
        -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
        -e "s|{{MODULE_NAME}}|$MODULE_NAME|g" \
        -e "s|{{GO_PATH}}|$GO_PATH|g" \
        -e "s|{{GO_ROOT}}|$GO_ROOT|g" \
        -e "s|{{GO_BIN_PATH}}|$GO_BIN_PATH|g" \
        -e "s|{{GO_PATH_DIR}}|$GO_PATH_DIR|g" \
        -e "s|{{GO_VERSION}}|$GO_VERSION_FULL|g" \
        -e "s|{{GO_MIN_VERSION}}|$GO_VERSION|g" \
        "$template_file" > "$output_file"

    log_info "Generated: $output_file"
}

# Generate all VSCode configuration files
generate_vscode_configs() {
    log_info "Generating VSCode configuration files..."

    # Generate settings.json for Go
    substitute_template "$TEMPLATES_DIR/settings-go.json.template" "$VSCODE_DIR/settings.json"

    # Generate tasks.json for Go
    substitute_template "$TEMPLATES_DIR/tasks-go.json.template" "$VSCODE_DIR/tasks.json"

    # Generate launch.json for Go debugging
    substitute_template "$TEMPLATES_DIR/launch-go.json.template" "$VSCODE_DIR/launch.json"

    # Generate extensions.json for Go development
    substitute_template "$TEMPLATES_DIR/extensions-go.json.template" "$VSCODE_DIR/extensions.json"

    # Generate Go code snippets
    substitute_template "$TEMPLATES_DIR/go.code-snippets.template" "$VSCODE_DIR/go.code-snippets"
}

# Create sample Go files if they don't exist
create_sample_files() {
    cd "$PROJECT_ROOT"
    if [[ ! -f "$PROJECT_ROOT/main.go" ]]; then
        log_info "Creating sample main.go file..."
        cat > "$PROJECT_ROOT/main.go" << EOF
package main

import (
	"fmt"
)

func main() {
	fmt.Println("Hello, $PROJECT_NAME!")
}
EOF
        log_success "Created main.go"
    fi

    # Create basic directory structure
    mkdir -p "$PROJECT_ROOT/cmd" "$PROJECT_ROOT/pkg" "$PROJECT_ROOT/internal"

    if [[ ! -f "$PROJECT_ROOT/.gitignore" ]]; then
        log_info "Creating .gitignore file..."
        cat > "$PROJECT_ROOT/.gitignore" << EOF
# Go binaries
*.exe
*.exe~
*.dll
*.so
*.dylib

# Test binary, built with \`go test -c\`
*.test

# Output of the go coverage tool, specifically when used with LiteIDE
*.out

# Go workspace files
go.work
go.work.sum

# IDE directories
.vscode/settings.json.bak
.idea/
*.swp
*.swo

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# Build artifacts
/bin/
/dist/
EOF
        log_success "Created .gitignore"
    fi
}

# Main execution function
main() {
    echo "VSCode Go Environment Setup"
    echo "=========================="
    echo

    parse_args "$@"
    detect_os
    check_go_installation

    if [[ "$INSTALL_GO" == true ]]; then
        install_go
    fi

    if [[ "$GO_INSTALLED" == true ]]; then
        check_go_tools
        init_go_module
    else
        log_error "Go is not available. Cannot proceed with setup."
        exit 1
    fi

    check_existing_config

    log_info "Configuration summary:"
    log_info "  Project: $PROJECT_NAME"
    log_info "  Module: $MODULE_NAME"
    log_info "  Go version: $(go version | cut -d' ' -f3)"
    log_info "  Go path: $GO_PATH"

    create_vscode_dir
    generate_vscode_configs
    create_sample_files

    log_success "VSCode Go environment setup completed!"
    log_info "Open this directory in VSCode to start developing."
    log_info "Make sure to install the Go extension if not already installed."
    echo
    log_info "Next steps:"
    log_info "1. Open VSCode in this directory: code ."
    log_info "2. Install the Go extension (golang.go) if prompted"
    log_info "3. VSCode will auto-install any missing Go tools when needed"
    log_info "4. Try running: go run main.go"
}

# Run main function with all arguments
main "$@"