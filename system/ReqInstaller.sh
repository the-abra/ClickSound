function apti() {
    while ! [[ "$(whereis $1)" =~ "/" ]]; do
    apti $1 -yq
    done
}

apti bc
apti wget
apti curl
apti python3
apti pip
apti sudo 
pip install pynput
pip install playsound