#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

files=(
	.zshrc .zsh_prompt .zsh_extra .completion-for-pnpm.zsh
)

for file in ${files[@]}; do
	[ -r "$file" ] && [ -f "$file" ] && ln -sfn ${BASEDIR}/"$file" ~/"$file";
done;
