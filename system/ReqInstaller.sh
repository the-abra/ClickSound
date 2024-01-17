function install() {
    if ! [[ "$(whereis $1)" =~ "/" ]]; then
        if [[ "$(uname)" == "Linux" ]]; then
            if [[ -x "$(command -v apt)" ]]; then
                apt install $1 -yq &>/dev/null
            elif [[ -x "$(command -v yum)" ]]; then
                yum install $1 -y &>/dev/null
            elif [[ -x "$(command -v dnf)" ]]; then
                dnf install $1 -y &>/dev/null
            elif [[ -x "$(command -v pacman)" ]]; then
                pacman -S $1 --noconfirm &>/dev/null
            else
                echo "Error: Package manager not found"
            fi
            ! [[ "$(whereis $1)" =~ "/" ]] && echo "$1 can't installed..." && exit 1
        elif [[ "$(uname)" == "Darwin" ]]; then
            if [[ -x "$(command -v brew)" ]]; then
                brew install $1
            else
                echo "Error: Homebrew not found"
            fi
        else
            echo "Error: Unsupported OS"
        fi
    else
        echo -e "$1 is Installed"
    fi
}


echo -ne "USING -> "
distro=$(cat /etc/os-release | grep -oP '(?<=^ID=).+' | tr -d '"' | sed 's/linux//')
if [[ -x "$(command -v apt)" ]]; then
    echo "$distro : apt"
elif [[ -x "$(command -v yum)" ]]; then
    echo "$distro : yum"
elif [[ -x "$(command -v dnf)" ]]; then
    echo "$distro : dnf"
elif [[ -x "$(command -v pacman)" ]]; then
    echo "$distro : pacman"
elif [[ -x "$(command -v brew)" ]]; then
    echo "$distro : brew"
else
    echo "Error: Package manager not found"
fi

install bc
install wget
install curl
install python3
install pip
pip install pynput playsound
distro=$(uname)

