#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

files=(
	.bash_profile .bash_prompt .bashrc
	.aliases .functions .exports 
	.hushlogin .path .extra .completion-for-pnpm.bash
)

for file in ${files[@]}; do
	[ -r "$file" ] && [ -f "$file" ] && ln -sfn ${BASEDIR}/"$file" ~/"$file";
done;