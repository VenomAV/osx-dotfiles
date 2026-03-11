#!/usr/bin/env bash

# fnm install v20
# fnm install v22
# fnm install v24
# fnm default v24
# fnm use v24

# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

mkdir -p tmp
curl -L https://github.com/g-plane/pnpm-shell-completion/releases/download/v0.5.5/pnpm-shell-completion_aarch64-apple-darwin.tar.gz -f -o tmp/pnpm-shell-completion.tar.gz
mkdir -p tmp/pnpm-shell-completion
tar -xzf ./tmp/pnpm-shell-completion.tar.gz -C ./tmp/pnpm-shell-completion
cd ./tmp/pnpm-shell-completion && ./install.zsh "$ZSH/custom/plugins" && cd ../..
rm -rf tmp

# BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ln -sfn ${BASEDIR}/terminal/starship.toml ~/.config/starship.toml

# pip3 install togglCli

# bash <(curl -L https://nixos.org/nix/install) --daemon
# mkdir -p ~/.config/nix
# ln -sfn ${BASEDIR}/.config/nix.conf ~/.config/nix/nix.conf

# if ! command -v rustup &> /dev/null
# then
#     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# fi