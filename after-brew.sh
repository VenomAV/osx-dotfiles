#!/usr/bin/env bash

fnm install v12.16.1
fnm install latest-v14.x
fnm default v12.16.1
fnm use v12.16.1

dotnet tool install --global dotnet-suggest
dotnet tool install --global amazon.lambda.tools
dotnet tool install --global fake-cli
dotnet tool install --global Paket

code --install-extension shan.code-settings-sync
