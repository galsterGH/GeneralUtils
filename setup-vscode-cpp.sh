#!/bin/bash

# VSCode C++ Environment Setup Script
# Automatically configures VSCode for C++ development with IntelliSense, build tasks, and debugging

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
    -n, --namespace NAME    Set C++ namespace (default: project name in PascalCase)
    -s, --standard VERSION  Set C++ standard (default: c++20)
    -b, --build-system TYPE Build system type: cmake, makefile, simple (default: auto-detect)
    -f, --force             Force overwrite existing VSCode configuration
    
Examples:
    $0                                  # Auto-detect everything
    $0 --project-name MyProject         # Set specific project name
    $0 --build-system cmake             # Force CMake build system
    $0 --namespace MyCompany::Utils     # Custom namespace

EOF
}

# Parse command line arguments
parse_args() {
    PROJECT_NAME=$(basename "$PROJECT_ROOT")
    NAMESPACE=""
    CPP_STANDARD="c++20"
    BUILD_SYSTEM=""
    FORCE_OVERWRITE=false
    
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
            -n|--namespace)
                NAMESPACE="$2"
                shift 2
                ;;
            -s|--standard)
                CPP_STANDARD="$2"
                shift 2
                ;;
            -b|--build-system)
                BUILD_SYSTEM="$2"
                shift 2
                ;;
            -f|--force)
                FORCE_OVERWRITE=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done
    
    # Default namespace to PascalCase project name
    if [[ -z "$NAMESPACE" ]]; then
        NAMESPACE=$(echo "$PROJECT_NAME" | sed 's/[^a-zA-Z0-9]//g' | sed 's/^./\U&/' | sed 's/[_-]\(.\)/\U\1/g')
    fi
}

# Detect operating system
detect_os() {
    case "$(uname -s)" in
        Darwin*)
            OS="macos"
            log_info "Detected macOS"
            ;;
        Linux*)
            OS="linux"
            log_info "Detected Linux"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            OS="windows"
            log_info "Detected Windows"
            ;;
        *)
            log_error "Unsupported operating system: $(uname -s)"
            exit 1
            ;;
    esac
}

# Detect C++ compiler and get configuration
detect_compiler() {
    log_info "Detecting C++ compiler and configuration..."
    
    case "$OS" in
        macos)
            detect_macos_compiler
            ;;
        linux)
            detect_linux_compiler
            ;;
        windows)
            detect_windows_compiler
            ;;
    esac
    
    log_info "Using compiler: $COMPILER_PATH"
    log_info "C++ standard: $CPP_STANDARD"
    log_info "IntelliSense mode: $INTELLISENSE_MODE"
}

# Detect macOS compiler (prefer Homebrew LLVM)
detect_macos_compiler() {
    # Check for Homebrew LLVM first (best C++20 support)
    if command -v /opt/homebrew/opt/llvm/bin/clang++ &> /dev/null; then
        COMPILER_PATH="/opt/homebrew/opt/llvm/bin/clang++"
        INTELLISENSE_MODE="clang-x64"
        COMPILER_ARGS='["-std=c++20", "-stdlib=libc++"]'
        DEFINES='["_LIBCPP_VERSION"]'
        INCLUDE_PATHS='[
            "${workspaceFolder}/include/**",
            "/opt/homebrew/opt/llvm/include/c++/v1",
            "/opt/homebrew/opt/llvm/lib/clang/18/include",
            "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include"
        ]'
        log_info "Found Homebrew LLVM"
    elif command -v clang++ &> /dev/null; then
        COMPILER_PATH=$(which clang++)
        INTELLISENSE_MODE="clang-x64"
        COMPILER_ARGS='["-std=c++20", "-stdlib=libc++"]'
        DEFINES='["_LIBCPP_VERSION"]'
        INCLUDE_PATHS='[
            "${workspaceFolder}/include/**",
            "/Library/Developer/CommandLineTools/usr/include/c++/v1",
            "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include"
        ]'
        log_info "Found system Clang"
    else
        log_error "No suitable C++ compiler found"
        exit 1
    fi
    
    DEBUG_TYPE="lldb"
}

# Detect Linux compiler
detect_linux_compiler() {
    if command -v clang++ &> /dev/null; then
        COMPILER_PATH=$(which clang++)
        INTELLISENSE_MODE="clang-x64"
        COMPILER_ARGS='["-std=c++20"]'
        DEFINES='[]'
        
        # Find libc++ include path
        LIBCPP_PATH=$(find /usr/include -name "c++" -type d 2>/dev/null | head -1)
        if [[ -n "$LIBCPP_PATH" ]]; then
            VERSION_DIR=$(ls "$LIBCPP_PATH" | grep -E '^[0-9]+$' | sort -nr | head -1)
            INCLUDE_PATHS="[
            \"${workspaceFolder}/include/**\",
            \"$LIBCPP_PATH/$VERSION_DIR\",
            \"/usr/local/include\",
            \"/usr/include\"
        ]"
        else
            INCLUDE_PATHS='[
            "${workspaceFolder}/include/**",
            "/usr/local/include",
            "/usr/include"
        ]'
        fi
        log_info "Found Clang"
    elif command -v g++ &> /dev/null; then
        COMPILER_PATH=$(which g++)
        INTELLISENSE_MODE="gcc-x64"
        COMPILER_ARGS='["-std=c++20"]'
        DEFINES='[]'
        
        # Find GCC include path
        GCC_VERSION=$(g++ -dumpversion | cut -d. -f1)
        INCLUDE_PATHS="[
            \"${workspaceFolder}/include/**\",
            \"/usr/include/c++/$GCC_VERSION\",
            \"/usr/include/c++/$GCC_VERSION/x86_64-linux-gnu\",
            \"/usr/local/include\",
            \"/usr/include\"
        ]"
        log_info "Found GCC"
    else
        log_error "No suitable C++ compiler found"
        exit 1
    fi
    
    DEBUG_TYPE="gdb"
}

# Detect Windows compiler (stub for now)
detect_windows_compiler() {
    log_error "Windows support not implemented yet"
    exit 1
}

# Detect build system
detect_build_system() {
    if [[ -n "$BUILD_SYSTEM" ]]; then
        log_info "Using specified build system: $BUILD_SYSTEM"
        return
    fi
    
    log_info "Auto-detecting build system..."
    
    if [[ -f "CMakeLists.txt" ]] || [[ -f "CMakePresets.json" ]]; then
        BUILD_SYSTEM="cmake"
        log_info "Detected CMake build system"
    elif [[ -f "Makefile" ]] || [[ -f "makefile" ]]; then
        BUILD_SYSTEM="makefile"
        log_info "Detected Makefile build system"
    else
        BUILD_SYSTEM="simple"
        log_info "No build system detected, using simple compilation"
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
    
    # Get compiler name for display
    COMPILER_NAME=$(basename "$COMPILER_PATH")
    
    # Perform variable substitution
    sed -e "s|{{OS_NAME}}|$OS|g" \
        -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
        -e "s|{{NAMESPACE}}|$NAMESPACE|g" \
        -e "s|{{COMPILER_PATH}}|$COMPILER_PATH|g" \
        -e "s|{{COMPILER_NAME}}|$COMPILER_NAME|g" \
        -e "s|{{CPP_STANDARD}}|$CPP_STANDARD|g" \
        -e "s|{{INTELLISENSE_MODE}}|$INTELLISENSE_MODE|g" \
        -e "s|{{DEBUG_TYPE}}|$DEBUG_TYPE|g" \
        -e "s|{{INCLUDE_PATHS}}|$INCLUDE_PATHS|g" \
        -e "s|{{COMPILER_ARGS}}|$COMPILER_ARGS|g" \
        -e "s|{{DEFINES}}|$DEFINES|g" \
        "$template_file" > "$output_file"
        
    log_info "Generated: $output_file"
}

# Generate all VSCode configuration files
generate_vscode_configs() {
    log_info "Generating VSCode configuration files..."
    
    # Generate c_cpp_properties.json
    substitute_template "$TEMPLATES_DIR/c_cpp_properties.json.template" "$VSCODE_DIR/c_cpp_properties.json"
    
    # Generate tasks.json based on build system
    case "$BUILD_SYSTEM" in
        cmake)
            substitute_template "$TEMPLATES_DIR/tasks-cmake.json.template" "$VSCODE_DIR/tasks.json"
            ;;
        makefile)
            substitute_template "$TEMPLATES_DIR/tasks-makefile.json.template" "$VSCODE_DIR/tasks.json"
            ;;
        simple)
            substitute_template "$TEMPLATES_DIR/tasks-simple.json.template" "$VSCODE_DIR/tasks.json"
            # Create build directory for simple compilation
            mkdir -p "$PROJECT_ROOT/build"
            ;;
    esac
    
    # Generate other configuration files
    substitute_template "$TEMPLATES_DIR/launch.json.template" "$VSCODE_DIR/launch.json"
    substitute_template "$TEMPLATES_DIR/settings.json.template" "$VSCODE_DIR/settings.json"
    substitute_template "$TEMPLATES_DIR/extensions.json.template" "$VSCODE_DIR/extensions.json"
    substitute_template "$TEMPLATES_DIR/cpp.code-snippets.template" "$VSCODE_DIR/cpp.code-snippets"
    
    # Generate .clang-format file if it doesn't exist
    if [[ ! -f "$PROJECT_ROOT/.clang-format" ]]; then
        generate_clang_format
    fi
    
    # Generate CMakePresets.json for CMake projects
    if [[ "$BUILD_SYSTEM" == "cmake" ]] && [[ ! -f "$PROJECT_ROOT/CMakePresets.json" ]]; then
        generate_cmake_presets
    fi
}

# Generate .clang-format configuration
generate_clang_format() {
    log_info "Creating .clang-format configuration..."
    cat > "$PROJECT_ROOT/.clang-format" << 'EOF'
---
BasedOnStyle: Google
IndentWidth: 2
ColumnLimit: 80
PointerAlignment: Left
ReferenceAlignment: Left
AlwaysBreakTemplateDeclarations: Yes
Standard: c++20
EOF
}

# Generate CMakePresets.json for CMake projects
generate_cmake_presets() {
    log_info "Creating CMakePresets.json..."
    cat > "$PROJECT_ROOT/CMakePresets.json" << EOF
{
    "version": 3,
    "configurePresets": [
        {
            "name": "base",
            "hidden": true,
            "generator": "Ninja",
            "binaryDir": "\${sourceDir}/build/\${presetName}",
            "cacheVariables": {
                "CMAKE_CXX_STANDARD": "${CPP_STANDARD##c++}",
                "CMAKE_CXX_STANDARD_REQUIRED": "ON",
                "CMAKE_EXPORT_COMPILE_COMMANDS": "ON"
            }
        },
        {
            "name": "debug",
            "displayName": "Debug Configuration",
            "inherits": "base",
            "cacheVariables": {
                "CMAKE_BUILD_TYPE": "Debug"
            }
        },
        {
            "name": "release",
            "displayName": "Release Configuration", 
            "inherits": "base",
            "cacheVariables": {
                "CMAKE_BUILD_TYPE": "Release"
            }
        }
    ],
    "buildPresets": [
        {
            "name": "debug",
            "configurePreset": "debug"
        },
        {
            "name": "release",
            "configurePreset": "release"
        }
    ],
    "testPresets": [
        {
            "name": "debug",
            "configurePreset": "debug",
            "output": {
                "outputOnFailure": true
            }
        }
    ]
}
EOF
}

# Main execution function
main() {
    echo "VSCode C++ Environment Setup"
    echo "============================"
    echo
    
    parse_args "$@"
    detect_os
    detect_compiler
    detect_build_system
    check_existing_config
    
    log_info "Configuration summary:"
    log_info "  Project: $PROJECT_NAME"
    log_info "  Namespace: $NAMESPACE" 
    log_info "  Build system: $BUILD_SYSTEM"
    log_info "  Compiler: $COMPILER_PATH"
    log_info "  Standard: $CPP_STANDARD"
    
    create_vscode_dir
    
    generate_vscode_configs
    
    log_success "VSCode C++ environment setup completed!"
    log_info "Open this directory in VSCode to start developing."
}

# Run main function with all arguments
main "$@"