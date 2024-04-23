#!/bin/bash
chmod +x shaman
mkdir -p ~/.local/bin/
cp shaman ~/.local/bin/

# enable autocomplete
shaman --install-completion
if [[ -f "~/.zshrc" ]]; then
    echo 'setopt menu_complete' >> ~/.zshrc
    echo 'compinit' >> ~/.zshrc
fi
