#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sfn ${BASEDIR}/starship.toml ~/.config/starship.toml