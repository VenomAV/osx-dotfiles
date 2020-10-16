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
brew install gnu-sed

# Install latest Bash.
brew install bash
brew install bash-completion2

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
brew install ssh-copy-id
brew install hugo
brew install starship
brew install Schniz/tap/fnm
brew install awscli
brew install yarn
brew install yarn-completion

brew install direnv

brew tap homebrew/command-not-found

####################################################
echo "installing cask apps"

brew tap homebrew/cask-versions

# Core casks
brew cask install iterm2

# Development tool casks
brew cask install visual-studio-code
brew cask install jetbrains-toolbox
brew cask install intellij-idea-ce
brew cask install rider
brew cask install webstorm
brew cask install datagrip

#Browsers
brew cask install google-chrome
brew cask install firefox
brew cask install firefox-developer-edition

# Misc casks
brew cask install vlc
brew cask install franz
brew cask install lastpass
brew cask install clipy
brew cask install gimp
brew cask install docker
brew cask install java
brew cask install keybase
brew cask install mongodb-compass-community
brew cask install betterzip
brew cask install miro

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook suspicious-package quicklookase qlvideo
xattr -d -r com.apple.quarantine ~/Library/QuickLook #Remove quarantine attributes on Catalina and later

brew cask install dotnet-sdk
brew tap isen-ng/dotnet-sdk-versions
brew cask install dotnet-sdk-2.1.800

brew cask install rectangle
brew cask install slack
brew cask install zoomus
brew cask install telegram
brew cask install google-drive-file-stream
brew cask install postman

######################################################
echo "Install cask fonts"
brew tap homebrew/cask-fonts
brew cask install font-fira-code

brew cleanup
