# create file system and auto start

function checkf() {
    file="$1"
    while ! [[ -f "$file" ]]; do
        echo -e "[INSTALLER] Error: $file is not created, create it manually. (press enter to continue)"
    done
}
function checkd() {
    diractory="$1"
    while ! [[ -d "$diractory" ]]; do
        echo -e "[INSTALLER] Error: $diractory is not created, create it manually. (press enter to continue)"
    done
}


echo -e "Installing python libs..."
source system/ReqInstaller.sh 1> /dev/null

echo -e "Crearting /usr/share/clicksound"
sudo mkdir /usr/share/clicksound
checkd '/usr/share/clicksound'
sudo chmod 777 /usr/share/clicksound

echo -e "Coping files to /usr/share/clicksound"
mv * /usr/share/clicksound
checkd '/usr/share/clicksound/system'
checkf '/usr/share/clicksound/main.sh'

echo -e "Creating /bin/clicksound"
sudo ln -s /usr/share/clicksound/main.sh /bin/clicksound
checkf '/bin/clicksound'
sudo chmod +x /bin/clicksound
sudo chmod 777 /bin/clicksound
