function install() {
    while ! [[ "$(whereis $1)" =~ "/" ]]; do
    if [[ "$(uname)" == "Linux" ]]; then
        if [[ -x "$(command -v apt)" ]]; then
            apt install $1 -yq
        elif [[ -x "$(command -v yum)" ]]; then
            yum install $1 -y
        elif [[ -x "$(command -v dnf)" ]]; then
            dnf install $1 -y
        elif [[ -x "$(command -v pacman)" ]]; then
            pacman -S $1 --noconfirm
        else
            echo "Error: Package manager not found"
        fi
    elif [[ "$(uname)" == "Darwin" ]]; then
        if [[ -x "$(command -v brew)" ]]; then
            brew install $1
        else
            echo "Error: Homebrew not found"
        fi
    else
        echo "Error: Unsupported OS"
    fi
    done
}

install bc
install wget
install curl
install python3
install pip
install sudo 
pip install pynput playsound
