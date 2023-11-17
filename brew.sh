#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install latest Bash.
brew install bash
brew install bash-completion@2

# Shell customization
brew install z
brew install fzf
brew install starship
brew install direnv

brew tap homebrew/command-not-found

# Development tool formulae
brew install git
brew install git-lfs
brew install git-delta
brew install icdiff #remeber to set it up with git
brew install mongosh
brew install hugo
brew install awscli
brew install aws-cdk
brew install awscurl
brew install yarn
brew install yarn-completion
brew install fnm
brew install exercism
brew tap mongodb/brew
brew install mongodb-database-tools

# Utils formulae
brew install tree
brew install bat
brew install fd
brew install httpie
brew install wget
brew install p7zip
brew install ncdu
brew install ssh-copy-id

####################################################
echo "installing cask apps"

brew tap homebrew/cask-versions

# Core casks
brew install --cask iterm2

# Development tool casks
brew install --cask visual-studio-code
brew install --cask jetbrains-toolbox
brew install --cask docker
brew install --cask postman
brew install --cask mongodb-compass
brew install --cask dotnet-sdk
brew tap isen-ng/dotnet-sdk-versions
brew install --cask dotnet-sdk6-0-400
brew install --cask dotnet-sdk8-0-100
brew install --cask figma
brew install --cask ngrok

# Browsers
brew install --cask google-chrome
brew install --cask firefox
brew install --cask firefox-developer-edition
brew install --cask tor-browser

# Communication
brew install --cask telegram
brew install --cask whatsapp
brew install --cask signal
brew install --cask skype
brew install --cask slack
brew install --cask zoom
brew install --cask webex
brew install --cask microsoft-teams

# Misc casks
brew install --cask raycast
brew install --cask alt-tab
brew install --cask notion
brew install --cask miro
brew install --cask google-drive-file-stream
brew install --cask vlc
brew install --cask gimp
brew install --cask keybase
brew install --cask calibre4
brew install --cask libreoffice
brew install --cask spotify
brew install --cask sublime-merge

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew install --cask qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo
xattr -d -r com.apple.quarantine ~/Library/QuickLook #Remove quarantine attributes on Catalina and later

######################################################
echo "Install cask fonts"
brew tap homebrew/cask-fonts
brew install --cask font-bebas-neue
brew install --cask font-fira-code
brew install --cask font-jetbrains-mono

brew cleanup
