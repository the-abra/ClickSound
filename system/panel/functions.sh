echo -ne "${tp}"
function LifeTime() {
target_date="2024-07-04"
today=$(date +%Y-%m-%d)
seconds_per_day=86400

target_epoch=$(date -d "$target_date" +%s)
current_epoch=$(date -d "$today" +%s)

time_diff=$((target_epoch - current_epoch))
days_diff=$((time_diff / seconds_per_day))

current_year=$(date -d "$today" +%Y)
leap_year=0

if (( (current_year % 4 == 0 && current_year % 100 != 0) || current_year % 400 == 0 )); then
  leap_year=1
fi

if [[ "$leap_year" == 1 && $(date -d "$today" +%m%d) > "0228" ]]; then
  days_diff=$((days_diff + 1))
fi
}

function getstatus() {
 if [[ "$(ps -aux | grep $(cat /home/$USER/.clicksound.pid))" =~ "sound.py" ]]; then
        if [[ "$1" = "noecho" ]]; then
          stat_value="${green}RUNNING${tp}"
        :
        else
          echo -e "[${brown}SYSTEM${tp}] Status ${green}RUNNING${tp} | ${blue}$(cat /home/$USER/.clicksound.pid)${tp}"
        :
        fi
    :
    else
        if [[ "$1" = "noecho" ]]; then
          stat_value="${red}Passive${tp}"
        :
        else
          echo -e "[${brown}SYSTEM${tp}] Status ${red}Passive${tp} | ${cyan}No keyboard sound active!"
        :
        fi
    :
 fi
}
function changetheme() {
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
    num=0;j=0;q=0;total=0

    echo -e "Themes List"
    echo -e "\n${tp}---------------------------------------------"
    for theme_num in ${elements[@]}; do
    let num+=1
    let total+=1
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

  read -e -p "$(echo -ne "Choose one: ")" choose
  if [[ $choose -gt $total ]]; then
    echo "Error: Invalid choice"
  else
    echo -e "Changing theme: $(cat system/sounds/$choose/name.file)"
    echo -e "$choose" > system/theme.txt
  fi
}
function startsound() {
    if [[ "$(ps -aux | grep $(cat /home/$USER/.clicksound.pid))" =~ "sound.py" ]]; then
        echo -e "[${brown}SYSTEM${tp}] Status ${green}RUNNING${tp} | ${blue}$(cat /home/$USER/.clicksound.pid)${tp}"
    :
    else
        cd system/
        python3 sound.py 2> "$wpath/error.txt" &
        soundpy_pid="$!"
        echo -e "$soundpy_pid" > /home/$USER/.clicksound.pid
        cd ..
        echo -e "[${brown}SYSTEM${tp}]: ${green}RUNNING ${tp}| ${blue}$soundpy_pid${tp}"
    :
    fi
}
function stopsound() {
    echo -e "Stopping..."
    killpid="$(cat /home/$USER/.clicksound.pid)"
    kill $killpid 2> "$wpath/error.txt"
    getstatus
}
function autostart() {
  if [[ -f /etc/xdg/autostart/clicksound.desktop ]]; then
    status="active"
  :
  else
    status="passive"
  :
  fi
  list="
  status: $status
  [1] enable
  [2] disable
  Choose opetion: "
  read -e -p "$(echo -ne "$list")" choose

  case "$choose" in
    1)
      echo -e "Creating autostart file"
      sudo cp clicksound.desktop /etc/xdg/autostart/clicksound.desktop
      ;;
    2)
      echo -e "Deleting autostart file"
      sudo rm /etc/xdg/autostart/clicksound.desktop
      ;;
    *)
      echo "Invalid option"
      ;;
  esac

}
function uninstall() {
  read -e -p "$(echo -ne "Are you sure? (y|N): ")" choose
  if [[ "$choose" =~ ^(y|Y) ]]; then
    echo -e "${Red}Deleting...${tp}"
    [[ -d /usr/share/clicksound ]] && echo -e "Deleting: /usr/share/clicksound" && sudo rm -rf /usr/share/clicksound
    [[ -f /bin/clicksound ]] && echo -e "Deleting: /bin/clicksound" && sudo rm -rf /bin/clicksound
    [[ -f /etx/xdg/clicksound.desktop ]] && echo -e "Deleting: /etx/xdg/clicksound.desktop" && sudo rm -rf /etx/xdg/clicksound.desktop 
    echo -e "${green}Done, system deleted succesfully! (press enter)"
    read nothing
  else
    echo -e "${green}Abroted!${tp}"
  fi
}
function checkupdate() {
  nver="$(curl https://raw.githubusercontent.com/the-abra/ClickSound/main/system/.ver)"
  cver="$(cat system/.ver)"
  if [[ "$cver" = "$nver" ]]; then
    echo -e "[SYSTEM] You are using ${green}latest version${tp} :D"
  :
  else
    echo -e "[SYSTEM] There is a update found ($cver -> $nver)"
    read -e -p "$(echo -e "Do you want to update? (Y|n)")" choose
    if [[ "$choose" =~ ^(n|N) ]]; then
      echo -e "[SYSTEM] Update ${red}Aborted${tp} version: $cver"
    :
    else
      echo -e "${green}Proccess started..."
      cd /home/$USER/
      echo -e "${green}Deleting old version..."
      [[ -d /usr/share/clicksound ]] && echo -e "Deleting: /usr/share/clicksound" && sudo rm -rf /usr/share/clicksound
      [[ -f /bin/clicksound ]] && echo -e "Deleting: /bin/clicksound" && sudo rm -rf /bin/clicksound
      [[ -f /etx/xdg/clicksound.desktop ]] && echo -e "Deleting: /etx/xdg/clicksound.desktop" && sudo rm -rf /etx/xdg/clicksound.desktop 
      echo -e "${green}Done, system deleted succesfully!"
      echo -e "${green}Installing new version..."
      wget https://github.com/the-abra/ClickSound/archive/refs/heads/main.zip
      unzip main.zip
      cd ClickSound-main/
      sudo bash .installer.sh
      cd ..
      sudo rm main.zip
      sudo rm -r ClickSound-main
      echo "Done."
    :
    fi
  :
  fi

}
