#!/bin/bash

echo "Installing shaman..."

# detect current shell
CURRENT_SHELL=$(echo $SHELL | rev | cut -d/ -f 1 | rev)
echo "Detected shell: $CURRENT_SHELL"

# copy binary
mkdir ~/.shaman
mkdir -p ~/.local/bin/
cp shaman ~/.local/bin/

# add to path
RC=".profile"
if [ $CURRENT_SHELL = "bash" ]; then
	RC=".bashrc"
elif [ $CURRENT_SHELL = "zsh" ]; then
	RC=".zshrc"
fi
export PATH=$PATH:~/.local/bin
echo "PATH=$PATH:~/.local/bin" >> $HOME/$RC

# install dependencies
# TODO: try to avoid using --break-system-packages
if pip install -r requirements.txt; then :
elif pip install -r requirements.txt --break-system-packages; then :
else echo "ERROR: Unable to install dependencies. Please install them manually."
fi

# enable autocomplete
if [ $CURRENT_SHELL = "bash" ]; then
	completion_dir=${BASH_COMPLETION_USER_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/bash-completion}/completions/
	mkdir -p $completion_dir
	shaman --tyro-write-completion bash ${completion_dir}/shaman
elif [ $CURRENT_SHELL = "zsh" ]; then
	mkdir -p ~/.zfunc
	shaman --tyro-write-completion zsh ~/.zfunc/shaman
	echo "fpath+=~/.zfunc" >> ~/.zshrc
	echo "autoload -Uz compinit && compinit" >> ~/.zshrc
fi

echo "Done!"
