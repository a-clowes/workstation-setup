echo
echo "Installing Git and associated tools"
brew install git

echo
echo "Setting global Git configurations"
git config --global core.editor "$(brew --prefix)/bin/vim"
git config --global transfer.fsckobjects true

mkdir -p ~/.git_templates
git config --global init.templateDir ~/.git_templates
echo "ref: refs/heads/main" > ~/.git_templates/HEAD

# Git UI tools (not needed: Git is built into VS Code and IntelliJ)
# brew install --cask sourcetree
# brew install --cask gitup
