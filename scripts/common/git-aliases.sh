echo
echo "Setting up Git aliases..."
git config --global alias.st status
git config --global alias.di diff
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.cp cherry-pick
git config --global alias.br branch
git config --global alias.sta stash
git config --global alias.llog "log --date=local"
git config --global alias.flog "log --pretty=fuller --decorate"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git config --global alias.lol "log --graph --decorate --oneline"
git config --global alias.lola "log --graph --decorate --oneline --all"
# Prints the repo's default branch (main or master) for the aliases below
git config --global alias.default-branch '!f() { b=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null); if [ -n "$b" ]; then echo "${b#origin/}"; elif git show-ref --verify --quiet refs/heads/main; then echo main; else echo master; fi; }; f'
git config --global alias.blog '!git log "origin/$(git default-branch)..." --left-right'
git config --global alias.ds "diff --staged"
git config --global alias.fixup "commit --fixup"
git config --global alias.squash "commit --squash"
git config --global alias.amendit "commit --amend --no-edit"
git config --global alias.unstage "reset HEAD"
git config --global alias.rum '!git rebase "$(git default-branch)@{u}"'
