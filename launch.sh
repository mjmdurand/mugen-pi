#!/bin/bash -e
echo -e "\e[1;32mKaraoke Mugen Raspi launcher\e[0m\n\n\e[1;33mPlease wait a moment, script is running\e[0m\n\n"

#start postgresql
sudo service postgresql start

#moving to user's directory
cd ~/karaokemugen-app

#launch Karaoke Mugen
#yarn startNoElectron
yarn start
