echo

# Don't exit if oh-my-zsh fails
set +e

echo "Installing Oh My Zsh (and don't exit if it's already installed)"
ZSH= sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# The installer moves an existing ~/.zshrc to ~/.zshrc.pre-oh-my-zsh;
# carry its PATH exports over so those directories stay on the PATH
if [ -f ~/.zshrc.pre-oh-my-zsh ]; then
  echo "Copying PATH exports from ~/.zshrc.pre-oh-my-zsh to ~/.zshrc"
  grep '^export PATH=' ~/.zshrc.pre-oh-my-zsh | while IFS= read -r line; do
    add_line_once "$line" ~/.zshrc
  done
fi

echo "Ignoring insecure completion-dependent directories."
echo "Needed when multiple admin users are using oh-my-zsh."
add_line_once 'ZSH_DISABLE_COMPFIX=true' ~/.zshenv

set -e
