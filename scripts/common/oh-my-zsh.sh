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

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Clone a repo only if it isn't there yet, so reruns don't fail
clone_once() {
  [ -d "$2" ] || git clone --depth=1 "$1" "$2"
}

echo "Installing zsh-autosuggestions, zsh-syntax-highlighting and Powerlevel10k"
clone_once https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
clone_once https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
clone_once https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM_DIR/themes/powerlevel10k"

echo "Enabling Powerlevel10k and plugins in ~/.zshrc"
# zsh-syntax-highlighting must be the last plugin
sed -i '' \
  -e 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' \
  -e 's|^plugins=(.*)|plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)|' \
  ~/.zshrc

# Powerlevel10k's instant prompt has to be at the very top of ~/.zshrc
if ! grep -q 'p10k-instant-prompt' ~/.zshrc; then
  {
    cat <<'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

EOF
    cat ~/.zshrc
  } > ~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc
fi
add_line_once 'alias zshconfig="code ~/.zshrc"' ~/.zshrc
add_line_once '# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.' ~/.zshrc
add_line_once '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' ~/.zshrc

echo "Ignoring insecure completion-dependent directories."
echo "Needed when multiple admin users are using oh-my-zsh."
add_line_once 'ZSH_DISABLE_COMPFIX=true' ~/.zshenv

set -e
