pip install -U pynvim
pip install -U 'python-lsp-server[all]' pylsp-mypy python-lsp-isort python-lsp-black

install_and_configure_node() {
    local os=$(uname -s)
    local arch=$(uname -m)
    local node_version="v20.14.0"
    local install_dir="$HOME/tools/node-$node_version-$os-$arch"

    # Function to append Node.js to PATH in .zshrc
    append_to_zshrc() {
        local path_line='export PATH="$1:$PATH"'
        local zshrc_path="$HOME/.zshrc"
        if command -v zsh &> /dev/null; then 
          zshrc_path="$HOME/.bashrc"
        fi

        # Check if PATH already exists in .zshrc
        if grep -q "$path_line" "$zshrc_path"; then
            echo "Node.js is already in PATH in $zshrc_path"
        else
            echo "$path_line" >> "$zshrc_path"
            echo "Node.js has been appended to PATH in $zshrc_path"
        fi
    }

    # Install Node.js based on OS and architecture
    case "$os-$arch" in
        Linux-x86_64)
            wget https://nodejs.org/dist/$node_version/node-$node_version-linux-x64.tar.xz -P /tmp
            tar xf /tmp/node-$node_version-linux-x64.tar.xz -C $HOME/tools --strip-components=1
            append_to_zshrc "$install_dir/bin"
            ;;
        Linux-aarch64)
            wget https://nodejs.org/dist/$node_version/node-$node_version-linux-arm64.tar.xz -P /tmp
            tar xf /tmp/node-$node_version-linux-arm64.tar.xz -C $HOME/tools --strip-components=1
            append_to_zshrc "$install_dir/bin"
            ;;
        Darwin-x86_64)
            wget https://nodejs.org/dist/$node_version/node-$node_version-darwin-x64.tar.gz -P /tmp
            tar xf /tmp/node-$node_version-darwin-x64.tar.gz -C $HOME/tools --strip-components=1
            append_to_zshrc "$install_dir/bin"
            ;;
        Darwin-arm64)
            wget https://nodejs.org/dist/$node_version/node-$node_version-darwin-arm64.tar.gz -P /tmp
            tar xf /tmp/node-$node_version-darwin-arm64.tar.gz -C $HOME/tools --strip-components=1
            append_to_zshrc "$install_dir/bin"
            ;;
        *)
            echo "Unsupported platform: $os-$arch"
            exit 1
            ;;
    esac
}

# Call the function to install and configure Node.js
install_and_configure_node

$install_dir/npm install -g vim-language-server


# Function to install ripgrep based on the OS and package manager
install_ripgrep() {
    local os=$(uname -s)
    local package_manager

    # Check the package manager based on the OS
    case "$os" in
        Linux)
            if command -v apt &> /dev/null; then
                package_manager="apt"
            elif command -v pacman &> /dev/null; then
                package_manager="pacman"
            elif command -v yum &> /dev/null; then
                package_manager="yum"
            elif command -v dnf &> /dev/null; then
                package_manager="dnf"
            else
                echo "Unsupported Linux distribution"
                exit 1
            fi
            ;;
        Darwin)
            package_manager="brew"
            ;;
        *)
            echo "Unsupported operating system: $os"
            exit 1
            ;;
    esac

    # Install ripgrep using the appropriate package manager
    case "$package_manager" in
        apt)
            sudo apt update
            sudo apt install ripgrep
            ;;
        pacman)
            sudo pacman -Sy ripgrep
            ;;
        yum)
            sudo yum install ripgrep
            ;;
        dnf)
            sudo dnf install ripgrep
            ;;
        brew)
            brew install ripgrep
            ;;
        *)
            echo "Unsupported package manager: $package_manager"
            exit 1
            ;;
    esac
}

# Call the function to install ripgrep
install_ripgrep

