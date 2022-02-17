#!/bin/bash -e

MUGEN_PI_DIR=$PWD
KARAOKE_MUGEN_DIR=~/karaokemugen-app
SONG_DIR=~/songs-karaokemugen
MPVREQUIRED=0.32.0-1
LOG=$PWD/log.txt

#Welcome message
clear
echo ""
echo " _  __                  _         __  __"
echo "| |/ /__ _ _ _ __ _ ___| |_____  |  \\/  |_  _ __ _ ___ _ _"
echo "| ' </ _\` | '_/ _\` / _ \\ / / -_) | |\\/| | || / _\` / -_) ' \\"
echo "|_|\\_\\__,_|_| \\__,_\\___/_\\_\\___| |_|  |_|\\_,_\\__, \\___|_||_|"
echo "                                             |___/"
echo ""
echo -e "\e[1;44mWelcome to Karaoke Mugen Installer\e[0m\n\e[1;33m/!\ It's recommanded to run this script under a wired connection.\nIf the installation fail, just launch the script once again\e[0m\n"
sleep 5

# select parameters
CHOICES=$(whiptail --title "Karaoke Mugen installation" --separate-output --checklist "Choose componements to install" 20 75 7 \
  "Core" "The KM app with all dependancies" ON \
  "Launch" "Launch KM with a desktop shortcut" ON \
  "Update" "Update KM with a desktop shortcut" ON \
  "Folders" "Use folders outside of KM app folder" ON \
  "Port" "Forward port 1337 to 80 for easy access" ON \
  "Wallpaper" "Change the wallpaper to a KM one" ON \
  "Filemanager" "Hide the \"open in terminal\" window " ON  3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
  for CHOICE in $CHOICES; do
    case "$CHOICE" in
    "Core")
      source ${MUGEN_PI_DIR}/lib/core.sh
      ;;
    "Launch")
      source ${MUGEN_PI_DIR}/lib/launch.sh
      echo -e "\e[1;33mYou need to restart to apply the changes (launch shortcut).\e[0m"
      whiptail --title "Karaoke Mugen installation" --msgbox "You'll need to restart or logout to finish the installation of the following element : \n\n- Launch shortcut" 15 60
      ;;
    "Update")
        source ${MUGEN_PI_DIR}/lib/update.sh
      echo "Option 3 was selected"
      echo -e "\e[1;33mYou need to restart to apply the changes (update shortcut).\e[0m"
      whiptail --title "Karaoke Mugen installation" --msgbox "You'll need to restart or logout to finish the installation of the following element : \n\n- Update shortcut" 15 60
      ;;
    "Folders")
    source ${MUGEN_PI_DIR}/lib/folders.sh
    echo -e "\n\e[1;44mSong folder will be located here ${SONG_DIR}\e[0m\n\e[1;41mPlease, keep the default values while the first start (${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/medias)\e[0m"
      whiptail --title "Karaoke Mugen installation" --msgbox "Song folder will be located here : \n${SONG_DIR} \n\nPlease, keep the default values while the first start (${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/medias)" 15 60
      ;;
    "Port")
    source ${MUGEN_PI_DIR}/lib/port.sh
      ;;
    "Wallpaper")
    source ${MUGEN_PI_DIR}/lib/wallpaper.sh
      echo "Option 4 was selected"
      echo -e "\e[1;33mYou need to restart to apply the changes (wallpaper).\e[0m"
      whiptail --title "Karaoke Mugen installation" --msgbox "You'll need to restart or logout to finish the installation of the following element : \n\n- Wallpaper" 15 60
      ;;
    "Filemanager")
    source ${MUGEN_PI_DIR}/lib/filemanager.sh
      echo "Option 5 was selected"
      echo -e "\e[1;33mYou need to restart to apply the changes (filemanager).\e[0m"
      whiptail --title "Karaoke Mugen installation" --msgbox "You'll need to restart or logout to finish the installation of the following element : \n\n- Filemanager" 15 60
      ;;
    *)
      echo "Unsupported choice : $CHOICE!" >&2
      exit 1
      ;;
    esac
  done
fi


#Finish installation
echo -e "\n\e[1;44mFinish installation.\e[0m"
echo -e "\e[1;33mYou need to restart to apply all changes (wallpaper, filemanager, shortcuts).\e[0m"
echo -e "\n\e[1;44mSong folder will be located here ${SONG_DIR}\e[0m\n\e[1;41mPlease, keep the default values while the first start (${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/medias)\e[0m"
echo -e "\n\e[1;32mInstallation finished, you can check log.txt if you have any issues to launch Karaoke Mugen.\e[0m"

# Display ending informations
whiptail --title "Karaoke Mugen installation" --msgbox "Installation finished, you can check log.txt if you have any issues to launch Karaoke Mugen." 15 60

# prompt for restart
if (whiptail --title "Karaoke Mugen installation" --yesno "Do you want to restart now to finish installation  ?" 15 60) then
	
    sudo reboot
else
	whiptail --title "Karaoke Mugen installation" --msgbox "You'll need to restart or logout later to finish the installation." 15 60
fi


