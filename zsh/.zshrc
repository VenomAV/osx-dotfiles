# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

## Use gnu tools instead (coreutils, sed)
if [[ "$(uname)" == "Darwin" ]] then
  export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$(brew --prefix coreutils)/libexec/gnubin:$PATH"
  export MANPATH="$(brew --prefix)/opt/gnu-sed/libexec/gnuman:$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
fi

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,zsh_prompt,exports,aliases,functions,zsh_extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;
