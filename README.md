# Workstation Setup

This project automates the process of setting up a new macOS software development machine using simple [Bash](https://www.gnu.org/software/bash/) scripting. It heavily relies on [homebrew](https://brew.sh/).

## Goals

The primary goal of this project is to give people a simple script they can run to make their macOS machine prepared and standardized for working on software development projects, especially those common at VMware Tanzu Labs.

## Why did we do it this way?

 * A bash script is easy for users to edit locally on-the-fly for small temporary tweaks
 * Everything is in one repository
 * The project name is informative
 * It is easy to fork and customize
 * It has limited requirements: `git` and `bash` available on macOS by default

## Anti-goals

This project does not aim to do everything. Some examples:

 * We don't install everything that your project needs. These scripts should only install generally useful things, and prefer running quickly over being complete.
 * We avoid setting up and maintaining overly-custom configurations. When there is already a tool that will get us something in a conventional manner, such as [Oh My Zsh](https://ohmyz.sh/), we prefer to use it instead of doing things ourselves.

## Preparation

- Run the latest version of macOS unless you have a specific reason not to
- These scripts might work on previous versions, but are maintained with only the latest macOS in mind
- Install the latest stable version of [Command Line Tools for Xcode](https://developer.apple.com/download/all/?q=Command%20Line%20Tools%20for%20Xcode)

## Getting this tool
Open up `Terminal.app` and run the following command:

```sh
mkdir -p ~/workspace &&
  cd ~/workspace &&
  git clone https://github.com/pivotal/workstation-setup.git &&
  cd workstation-setup
```

**Note:** This might prompt you to install the latest Xcode command line development tools. Please do so if prompted. 

## Using this tool
Within `~/workspace/workstation-setup`, run the following:

```shell
./setup.sh [list of optional configurations]
```

Examples:
```shell
# This will only install the default items
./setup.sh 

# This will install Java and JavaScript (Node) development tools
./setup.sh java node
```

**Warning: this tool might overwrite existing configurations.** In particular, `scripts/common/configuration-osx.sh` removes every icon from your Dock, hides the Dock, sets a very fast key repeat, and replaces your iTerm and Rectangle settings. Comment out anything you don't want before running.

The scripts are safe to rerun: lines added to your shell config files (`~/.zshrc`, `~/.zshenv`, `~/.zprofile`) are only added once.

### Items installed by default
We recommend that you look at `setup.sh` to see what is automatically installed. You'll see it calls other scripts within `scripts/common`, so feel free to take a look at those, too. In summary:

 * **Homebrew** and **Oh My Zsh**. Oh My Zsh replaces `~/.zshrc` (keeping a backup in `~/.zshrc.pre-oh-my-zsh`); any `export PATH=...` lines from your old `~/.zshrc` are copied into the new one.
 * **Editors:** Visual Studio Code and Vim
 * **Git:** the latest Git, global settings (Vim as editor, `main` as the default branch for new repos) and [Git aliases](#git-aliases)
 * **Applications:** Flycut, iTerm2, Google Chrome, Firefox, Slack and Zoom
 * **Developer utilities:** Dash and Postman
 * **Command-line tools:** autojump, grc, coreutils, watch, direnv, pstree, the_silver_searcher, wget and jq
 * **macOS settings:** see the warning above

 Note that you can edit any of those files to add or remove items specific for your needs, but the goal of this project is to have sane defaults for our target audience.

### Opt-In Configurations
Please look in `scripts/opt-in/` for optional, opt-in configurations. Some of these are languages and associated frameworks, such as `java` and `golang`. Some are supporting infrastructure, such as `docker` and `kubernetes`. Others might be specific tools for application platforms, such as `cloud-foundry`.

To install any of these, add them as arguments to `$> setup.sh`. Examples: 

```sh
# Java and JavaScript development
./setup.sh java node

# Common for Spring Boot development
./setup.sh java spring-boot docker

# Lots of languages
./setup.sh java ruby node golang python c

# Love those platforms!
./setup.sh golang docker kubernetes cloud-foundry terraform concourse
```

### Managing Java and Node versions

Projects often need a specific Java or Node version, so `java` and `node` install version managers rather than a single version.

**Java** (`java`): installs OpenJDK 17, 21 and 25 from Homebrew, plus [jenv](https://www.jenv.be/) to switch between them. JDK 25 is the default. jenv also keeps `JAVA_HOME` pointing at the active JDK, so Maven, Gradle and IntelliJ use it. It also installs IntelliJ IDEA, Maven and Gradle.

```sh
jenv versions     # list installed JDKs
jenv local 17     # use JDK 17 in this project (writes .java-version)
jenv global 21    # change the default JDK
```

To install different JDKs, edit `JDK_VERSIONS` at the top of `scripts/opt-in/java.sh`. The last version listed becomes the default.

**Node** (`node`): installs [fnm](https://github.com/Schniz/fnm) and the latest LTS version of Node. When you `cd` into a project with a `.node-version` or `.nvmrc` file, fnm switches to that version.

```sh
fnm install 20    # install Node 20
fnm use 20        # use it in the current shell
fnm default 20    # make it the default
```

Open a new terminal after setup so jenv and fnm are loaded.

## Git aliases

`scripts/common/git-aliases.sh` sets these global aliases:

| Alias | Runs |
|---|---|
| `git st` | `git status` |
| `git di` | `git diff` |
| `git ds` | `git diff --staged` |
| `git co` | `git checkout` |
| `git ci` | `git commit` |
| `git cp` | `git cherry-pick` |
| `git br` | `git branch` |
| `git sta` | `git stash` |
| `git llog` | log with local dates |
| `git flog` | log with full author and committer details |
| `git lg` | colourful one-line graph log |
| `git lol` / `git lola` | one-line graph log of the current branch / all branches |
| `git blog` | commits that differ between your branch and the remote default branch |
| `git rum` | rebase onto the upstream of the default branch |
| `git fixup` / `git squash` | `git commit --fixup` / `git commit --squash` |
| `git amendit` | amend the last commit without editing its message |
| `git unstage` | `git reset HEAD` |
| `git default-branch` | print the repo's default branch |

`blog` and `rum` work in repos that use either `main` or `master`. They use the remote's default branch (`origin/HEAD`), falling back to `main` if it exists locally, otherwise `master`.

## Analytics

This tool doesn't collect any usage data. It also turns off Homebrew's [analytics](https://docs.brew.sh/Analytics).

## Having problems?

If you're having problems using the setup script, please let us know by [opening an issue](https://github.com/pivotal/workstation-setup/issues/new).

If you see errors from `brew`, try running `brew doctor` and include the diagnostic output in your issue submission.

## Customizing

If you'd like to customize this project for a project's use:

- Fork the project
- Edit the shells scripts to your liking
- Profit

## Frequently Asked Questions and Troubleshooting
_Q: Can I rerun `setup.sh`?_

A: Yes, but with a _but_. While this script is not entirely [idempotent](https://en.wikipedia.org/wiki/Idempotence), it does use homebrew's cache to skip reinstalling items, and is pretty lenient about ignoring errors when non-homebrew items get mad that they are already installed. There is no guarantee that some configurations won't be overwritten or duplicated. 

_Q: Should I run this with `sudo`?_

A: No. `setup.sh` will ask you for your password and take care of that for you.

_Q: I'm getting permission errors such as the one below:_
```sh 
Error: Can't create update lock in /usr/local/var/homebrew/locks!
Fix permissions by running:
  sudo chown -R $(whoami) /usr/local/var/homebrew
```
A: **Short answer:** run the suggested command or consider the **Possible Solution** described below.

**Longer answer:** You might have multiple user profiles on your machine that are using homebrew (such as this tool) resulting in a mix of file and directory ownership under `/usr/local/var/homebrew`. This should mostly be an issue with installing things, but not using the tools installed by `brew`. If you switch between profiles _and_ install tools using `brew` often you might run into this a lot.

**Possible Solution:** Try this solution from [itectec](https://itectec.com/superuser/enable-multiple-users-to-install-software-using-homebrew/) which makes homebrew's directories writable by the `staff` group, which should be all admin users on your machine.

1. Note your default `umask` for later.

   ```shell
    $> umask
    022
    ```

2. Set homebrew's directories to be writable by everyone in the `staff` group.

    ```shell
    umask 002 # group write permission
    sudo chmod -R g+w /usr/local/* # group writable
    sudo chgrp -R staff /usr/local/* # staff owned
    ```

3. Set your `umask` back to the default.

   ```shell
    umask 022 # or whatever you noted earlier
   ```

_Q: How do I get my change into this tool?_

A: Submit a PR, especially for things that are outdated or broken. But, we are being vigilant about keeping this tool lean after a history of letting many idiosyncratic changes creep in over the past few years. As stated above, you can edit the files yourself after downloading them and/or fork.
