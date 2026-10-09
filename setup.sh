#!/usr/bin/env bash
#
# setup.sh:  run the workstation setup
#
# Arguments:
#   - a list of components to install, see scripts/opt-in/ for valid options
#

# Fail immediately if any errors occur
set -e

echo "Caching password..."
sudo -K
sudo true;
clear

MY_DIR="$(cd "$(dirname "$0")" && pwd)"

# Append a line to a file only if it is not already there, so reruns don't duplicate config
add_line_once() {
    touch "$2"
    grep -qxF -- "$1" "$2" || echo "$1" >> "$2"
}

# Don't send Homebrew analytics during setup (homebrew.sh also turns them off permanently)
export HOMEBREW_NO_ANALYTICS=1

# Note: Homebrew needs to be set up first
source "${MY_DIR}/scripts/common/homebrew.sh"

# Install everything else
source "${MY_DIR}/scripts/common/oh-my-zsh.sh"
source "${MY_DIR}/scripts/common/editors.sh"
source "${MY_DIR}/scripts/common/git.sh"
source "${MY_DIR}/scripts/common/git-aliases.sh"
source "${MY_DIR}/scripts/common/applications-common.sh"
source "${MY_DIR}/scripts/common/developer-utilities.sh"
source "${MY_DIR}/scripts/common/unix.sh"
source "${MY_DIR}/scripts/common/configuration-osx.sh"

# For each command line argument, try executing the corresponding script in opt-in/
for var in "$@"
do
    echo "$var"
    FILE="${MY_DIR}/scripts/opt-in/${var}.sh"
    echo "$FILE"
    if [ -f "$FILE" ]; then
        source "${FILE}"
    else
       echo "Warning: $var does not appear to be a valid argument. File $FILE does not exist."
    fi
done

source "${MY_DIR}/scripts/common/finished.sh"
