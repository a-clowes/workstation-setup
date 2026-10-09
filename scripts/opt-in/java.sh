echo
echo "Installing OpenJDK LTS versions and jenv to switch between them"

# JDK major versions to install; the last one becomes the global default
JDK_VERSIONS="17 21 25"

brew install jenv

# Load jenv in new shells; it switches to the version in a project's
# .java-version file (set with 'jenv local <version>') when you cd into it
add_line_once 'eval "$(jenv init -)"' ~/.zshrc
eval "$(jenv init -)"

for version in $JDK_VERSIONS; do
    brew install "openjdk@${version}"

    # Configure as instructed by 'brew info openjdk@<version>' so macOS tools like /usr/libexec/java_home find it
    sudo ln -sfn "$(brew --prefix)/opt/openjdk@${version}/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk-${version}.jdk"

    jenv add "$(brew --prefix)/opt/openjdk@${version}/libexec/openjdk.jdk/Contents/Home"
done

jenv global "$version"

# Keep JAVA_HOME pointing at the active JDK so Maven, Gradle and IDEs use it
jenv enable-plugin export || true

# more java tools
source "${MY_DIR}/scripts/opt-in/java-tools.sh"
