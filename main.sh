#!/bin/bash

# Check if the script is run as root
if [[ "$EUID" -ne 0 ]]; then
    echo -e "Root access is can't provided."
    exit 1
fi


app_name="clicksound"

#check path
    if ! [[ -f "/root/.clicksound.path" ]]; then
        touch "/root/.clicksound.path"
        echo -e "/usr/share/clicksound" > /root/.clicksound.path 
    fi
    if ! [[ -f "/root/.clicksound.pid" ]]; then
        touch "/root/.clicksound.pid"
    fi


    if [[ "$(ls $(pwd))" =~ "system" ]]; then
        wpath="$(pwd)"
    :
    elif [[ -d "/usr/share/clicksound" ]]; then
        wpath="/usr/share/clicksound"
    :
    elif [[ "$(ls $(cat /root/.clicksound.path))" =~ "system" ]]; then
        wpath="$(cat /root/.clicksound.path)"
    :
    else
        check="none"
        while [[ "$check" != "pass" ]]; do
            read -e -p "$(echo -ne "Type the work path: ")" newpath
            if [[ "$(ls $newpath)" =~ "system" ]]; then
                check="pass"
                echo -e "[SYSTEM] New path -> $newpath"
                wpath="$newpath"
                echo -e "$wpath" > /root/.clicksound.path
                :
            else
                echo -e "[SYSTEM] Files not found (false path $newpath)"
                :
            fi
        done
    :
    fi
    cd $wpath


source system/colors.sh


function startpy() {
    if [[ "$(ps -aux | grep $(cat /root/.clicksound.pid))" =~ "sound.py" ]]; then
        echo -e "[${brown}SYSTEM${tp}] Status ${green}RUNNING${tp} | ${blue}$(cat /root/.clicksound.pid)${tp}"
    :
    else
        cd system/
        python3 sound.py 2> "$wpath/error.txt" &
        soundpy_pid="$!"
        echo -e "$soundpy_pid" > /root/.clicksound.pid
        cd ..
        echo -e "[${brown}SYSTEM${tp}]: ${green}RUNNING ${tp}| ${blue}$soundpy_pid${tp}"
    :
    fi
}


if [[ "$1" =~ ^(h|H) ]]; then
    echo "Usage: clicksound [-h]"
    cat system/help.txt
    exit 0
:
elif [[ "$1" = "stop" ]]; then
    echo -e "Stopping..."
    killpid="$(cat /root/.clicksound.pid)"
    kill $killpid 2> "$wpath/error.txt"
    if ! [[ "$(ps -aux | grep $(cat /root/.clicksound.pid))" =~ "sound.py" ]]; then
        echo -e "[${brown}SYSTEM${tp}] Status ${red}STOPPED${tp} | ${blue}$(cat /root/.clicksound.pid)${tp}"
        echo -e "0000" > /root/.clicksound.pid
    :
    fi
:
elif [[ "$1" = "status" ]]; then
    if [[ "$(ps -aux | grep $(cat /root/.clicksound.pid))" =~ "sound.py" ]]; then
        echo -e "[${brown}SYSTEM${tp}] Status ${green}RUNNING${tp} | ${blue}$(cat /root/.clicksound.pid)${tp}"
    :
    else
        echo -e "[${brown}SYSTEM${tp}] Status ${red}Passive${tp} | ${cyan}No keyboard sound active!"
    :
    fi
:
elif [[ "$1" = "themes" ]]; then
    
    elements=($(ls system/sounds))

    function write() {
                echo -e "${tp}[${blue}$2${tp}] ${brown}$1"
    }
    function write_ne() {
                echo -ne "${tp}[${blue}$2${tp}] ${brown}$1"
    }

    function spacer() {
        letter=$(echo -n "[$num] $module: $status" | wc -c)
        space=$(echo -e "35-$letter" | bc)
        for (( q = 0; q <= $space; q++ )); do
            echo -ne " "
        done
    }

    elements=($(ls system/sounds))
    num=0;j=0;q=0

    echo -e "Themes List"
    echo -e "\n${tp}---------------------------------------------"
    for theme_num in ${elements[@]}; do
    let num+=1
    if [[ "$j" = "1" ]]; then
        write $(cat system/sounds/$theme_num/name.file) $num && j=0    # right block
        :
    elif [[ "$j" = "0" ]]; then
        write_ne $(cat system/sounds/$theme_num/name.file) $num && j=1 # left block
        spacer
        :
    fi
    done
    echo -e "\n${tp}---------------------------------------------"

:
elif [[ "$1" = "panel" ]]; then
    source system/panel/panel.sh
:
else
    echo "No arguments or start supplied, starting normally..."
    startpy
fi
