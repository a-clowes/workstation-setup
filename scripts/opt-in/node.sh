echo
echo "Installing fnm (Fast Node Manager) to manage NodeJS versions"

brew install fnm

# Load fnm in new shells; --use-on-cd switches to the version in a
# project's .node-version or .nvmrc when you cd into it
add_line_once 'eval "$(fnm env --use-on-cd --shell zsh)"' ~/.zshrc

echo
echo "Installing latest LTS version of NodeJS"
eval "$(fnm env --shell bash)"
# The first version fnm installs becomes the default
fnm install --lts
