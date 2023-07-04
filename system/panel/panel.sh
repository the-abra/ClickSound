#Call functions
source system/panel/functions.sh

#run funtions
LifeTime
getstatus noecho
#set banner
echo -e "
(_______) |(_)     | |       / _____)                     | | & auth: ${red}the-abra${tp}
 _      | | _  ____| |  _   ( (____   ___  _   _ ____   __| | & repo: ${cyan}ClickSound${tp}
| |     | || |/ ___) |_/ )   \____ \ / _ \| | | |  _ \ / _  | & vers: ${blue}dev${tp}
| |_____| || ( (___|  _ (    _____) ) |_| | |_| | | | ( (_| | & stat: $stat_value
 \______)\_)_|\____)_| \_)  (______/ \___/|____/|_| |_|\____| & LifeTime: $days_diff days left
"
echo -e "Choose setting menu"
list="
[1] ${brown}change theme${tp}
[2] ${brown}start sounds${tp}
[3] ${brown}stop sounds${tp}
[4] ${brown}auto start${tp}
[5] ${red}Uninstall${tp}

Enter your choice: ${yellow}"

#set switch case

read -e -p "$(echo -ne "$list")" choice
case $choice in
    1) changetheme ;;
    2) startsound ;;
    3) stopsound ;;
    4) autostart ;;
    5) uninstall ;;
    *) echo "Invalid choice.";;
esac

exit 0