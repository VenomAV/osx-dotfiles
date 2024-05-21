#!/usr/bin/env bash

fnm install v16
fnm install v18
fnm install v20
fnm default v20
fnm use v20

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sfn ${BASEDIR}/terminal/starship.toml ~/.config/starship.toml

pip3 install togglCli

bash <(curl -L https://nixos.org/nix/install) --daemon
mkdir -p ~/.config/nix
ln -sfn ${BASEDIR}/.config/nix.conf ~/.config/nix/nix.conf
