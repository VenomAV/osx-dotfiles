#!/bin/bash

set -euo pipefail

BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "$BASEDIR"

files=(
	.aerospace.toml
)

for file in ${files[@]}; do
	[ -r "$file" ] && [ -f "$file" ] && ln -sfn ${BASEDIR}/"$file" ~/"$file";
done;

OVERLAY_SOURCE="${BASEDIR}/workspace-overlay/WorkspaceOverlay.swift"
OVERLAY_INSTALL_DIR="${HOME}/.local/bin"
OVERLAY_BINARY="${OVERLAY_INSTALL_DIR}/aerospace-workspace-overlay"
SWIFT_COMPILER="$(xcrun --find swiftc 2>/dev/null || true)"
MACOS_MAJOR_VERSION="$(sw_vers -productVersion | cut -d. -f1)"
SWIFT_SDK="$(find "$(xcode-select -p)/SDKs" -maxdepth 1 -type d -name "MacOSX${MACOS_MAJOR_VERSION}*.sdk" 2>/dev/null | sort | tail -n 1)"

if [ -z "$SWIFT_COMPILER" ]; then
	echo "swiftc is required to build the AeroSpace workspace overlay." >&2
	echo "Install the Xcode Command Line Tools with: xcode-select --install" >&2
	exit 1
fi

mkdir -p "$OVERLAY_INSTALL_DIR"
if [ ! -x "$OVERLAY_BINARY" ] || [ "$OVERLAY_SOURCE" -nt "$OVERLAY_BINARY" ]; then
	echo "Building AeroSpace workspace overlay..."
	if [ -n "$SWIFT_SDK" ]; then
		SWIFT_TARGET="$(uname -m)-apple-macosx${MACOS_MAJOR_VERSION}.0"
		"$SWIFT_COMPILER" -sdk "$SWIFT_SDK" -target "$SWIFT_TARGET" -O "$OVERLAY_SOURCE" -o "$OVERLAY_BINARY"
	else
		"$SWIFT_COMPILER" -O "$OVERLAY_SOURCE" -o "$OVERLAY_BINARY"
	fi
else
	echo "AeroSpace workspace overlay is already up to date."
fi
