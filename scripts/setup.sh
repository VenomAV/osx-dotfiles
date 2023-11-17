#!/bin/bash

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

files=(
	one-liner-json
	toggl-add
)

mkdir ~/.local/bin

for file in ${files[@]}; do
	[ -r "$file" ] && [ -f "$file" ] && ln -sfn ${BASEDIR}/"$file" ~/.local/bin/"$file";
done;
