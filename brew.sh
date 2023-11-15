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

## Switch to using brew-installed bash as default shell
#if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
#  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
#  chsh -s "${BREW_PREFIX}/bin/bash";
#fi;

brew install tree
brew install z
brew install fzf
brew install bat
brew install fd
brew install httpie
brew install wget
brew install icdiff #remeber to set it up with git
brew install p7zip
brew install ncdu
brew install git
brew install git-lfs
brew install git-delta
brew install ssh-copy-id
brew install hugo
brew install starship
brew install Schniz/tap/fnm
brew install awscli
brew install aws-cdk
brew install yarn
brew install yarn-completion
brew install direnv

brew tap homebrew/command-not-found

####################################################
echo "installing cask apps"

brew tap homebrew/cask-versions

# Core casks
brew install --cask iterm2

# Development tool casks
brew install --cask visual-studio-code
brew install --cask jetbrains-toolbox
brew install --cask intellij-idea-ce
brew install --cask rider
brew install --cask webstorm
brew install --cask datagrip

#Browsers
brew install --cask google-chrome
brew install --cask firefox
brew install --cask firefox-developer-edition

# Misc casks
brew install --cask vlc
brew install --cask franz
brew install --cask lastpass
brew install --cask clipy
brew install --cask gimp
brew install --cask docker
brew install --cask java
brew install --cask keybase
brew install --cask mongodb-compass-community
brew install --cask betterzip
brew install --cask miro
brew install mongosh

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew install --cask qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo
xattr -d -r com.apple.quarantine ~/Library/QuickLook #Remove quarantine attributes on Catalina and later

brew install --cask dotnet-sdk
brew tap isen-ng/dotnet-sdk-versions
brew install --cask dotnet-sdk-2.1.800

brew install --cask rectangle
brew install --cask slack
brew install --cask zoomus
brew install --cask telegram
brew install --cask google-drive-file-stream
brew install --cask postman

######################################################
echo "Install cask fonts"
brew tap homebrew/cask-fonts
brew install --cask font-fira-code

brew cleanup
