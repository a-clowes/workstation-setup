# Don't stop if docker fails
set +e

# Docker
brew install --cask docker
echo "To get docker command-line tools, run the docker application"

# Docker Zsh Completion
# Reference https://docs.docker.com/docker-for-mac/
etc=/Applications/Docker.app/Contents/Resources/etc
ln -sf "$etc/docker.zsh-completion" "$(brew --prefix)/share/zsh/site-functions/_docker"
ln -sf "$etc/docker-compose.zsh-completion" "$(brew --prefix)/share/zsh/site-functions/_docker-compose"

set -e
