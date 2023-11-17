#!/usr/bin/env bash

fnm default v16
fnm install v18
fnm install v20
fnm use v16

dotnet tool install --global dotnet-suggest
dotnet tool install --global amazon.lambda.tools
dotnet tool install --global fake-cli
dotnet tool install --global Paket

code --install-extension shan.code-settings-sync

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sfn ${BASEDIR}/terminal/starship.toml ~/.config/starship.toml
