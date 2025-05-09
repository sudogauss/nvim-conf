#!/bin/bash

# Check script is running with sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "Script must be run as root to install dependecies"
    exit 1
fi

# error codes
pkg_install_fail_err_code=20
repo_fetch_err_code=21
tar_err_code=22
build_err_code=23

# required apt dependencies
required_packages=(
    "curl"
    "lua5.4"
    "lublua5.4-dev"
    "build-essential"
    "make"
    "wget"
)

# repositories
nvim_repo="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
luarocks_repo="https://luarocks.org/releases/luarocks-3.11.1.tar.gz"

# helper
exit_with_error () {
    echo "An error has occured: $1"
    exit $2
}

# helper
print_title () {
    echo "=============================="
    echo "$1"
    echo "=============================="
}

# Install packages listed in required_packages
install_required_packages () {
    local IFS=" "
    print_title "Installing Required Packages"
    sudo apt update && sudo apt install -y $(echo "${required_packages[*]}") || exit_with_error "apt install failed" $pkg_install_fail_err_code
}

# Fetch and install neovim
install_neovim () {
    print_title "Installing Neovim"
    curl -LO $nvim_repo || exit_with_error "failed to fetch neovim" $repo_fetch_err_code
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz || exit_with_error "failed to untar neovim" $tar_err_code
    rm nvim-linux-x86_64.tar.gz
    echo "export PATH=\"\$PATH:/opt/nvim-linux-x86_64/bin\"" >> ~/.bashrc
    echo "Neovim has been installed, restart your "
}

# Fetch and install luarocks (lua package manager)
install_luarocks () {
    wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz || exit_with_error "failed to fetch luarocks" $repo_fetch_err_code
    tar zxpf luarocks-3.11.1.tar.gz || exit_with_error "failed to untar luarocks" $tar_err_code
    cd luarocks-3.11.1/ && ./configure && make && sudo make install || exit_with_error "failed to build and install luarocks" $build_err_code
    rm luarocks-3.11.1
}

# Install Node, generally needed for some UI imrovements
install_node () {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash || exit_with_error "failed to fetch Node" $pkg_install_fail_err_code
    \. "$HOME/.nvm/nvm.sh" || exit_with_error "failed to install Node manager" $?
    nvm install 22
}

# ===== LSP SERVERS =====

install_python_lsp_server () {
    sudo apt update && sudo apt install python3 python3-pip || exit_with_error "failed to install python and pip" $pkg_install_fail_err_code
    pip3 install pyright --break-system-packages || exit_with_error "failed to install pyright lsp server system wide" $pkg_install_fail_err_code
}

# ===== Plugins =====

install_nvim_plugins () {}