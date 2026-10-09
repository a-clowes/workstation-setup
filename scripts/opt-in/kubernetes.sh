echo
echo "Installing common Kubernetes tooling"

brew install kubectl
# Shell completion (compinit must run before kubectl's completion is loaded;
# zsh completes the k alias as kubectl automatically)
add_line_once 'autoload -Uz compinit && compinit' ~/.zshrc
add_line_once 'source <(kubectl completion zsh)' ~/.zshrc
add_line_once 'alias k=kubectl' ~/.zshrc
