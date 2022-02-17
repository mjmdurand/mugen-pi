#!/bin/bash -e

echo ""
echo " _  __                  _         __  __"
echo "| |/ /__ _ _ _ __ _ ___| |_____  |  \\/  |_  _ __ _ ___ _ _"
echo "| ' </ _\` | '_/ _\` / _ \\ / / -_) | |\\/| | || / _\` / -_) ' \\"
echo "|_|\\_\\__,_|_| \\__,_\\___/_\\_\\___| |_|  |_|\\_,_\\__, \\___|_||_|"
echo "                                             |___/"
echo ""
echo -e "\e[1;32mKaraoke Mugen Raspi launcher\e[0m\n\n\e[1;33mPlease wait a moment, script is running\e[0m\n\n"

#start postgresql
sudo service postgresql start

#moving to user's directory
cd ~/karaokemugen-app

#launch Karaoke Mugen without electron
#yarn startNoElectron

#launch Karaoke Mugen with electron
yarn start
