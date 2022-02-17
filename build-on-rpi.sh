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
echo -e "\e[44mWelcome to Karaoke Mugen Installer\e[0m\n\n\e[1;33m/!\ It's recommanded to run this script under a wired connection.\nIf the installation fail, just launch the script once again\e[0m\n"
sleep 5

# update system and install softwares
echo -e "\e[44mUpdating the system.\e[0m"
sudo apt update -q &> ${LOG} && sudo apt upgrade -yq &> ${LOG}
echo -e "\e[1;32mSystem updated.\e[0m"

echo -e "\n\e[44mInstalling required software.\e[0m"
# adding nodejs 14.x repositories
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash - &>> ${LOG}
sudo apt install -yq nodejs mpv ffmpeg postgresql libpq-dev postgresql-client postgresql-client-common git &>> ${LOG}
sudo npm install -g yarn &>> ${LOG}
sudo apt autoremove -yq &>> ${LOG}
echo -e "\e[1;32mRequired software installation done.\e[0m"

#checking mpv version
echo -e "\n\e[44mCheking MPV version.\e[0m"
MPVVERS=`dpkg -s mpv | grep Version | cut -c10-`
MPVTEST=`dpkg --compare-versions ${MPVVERS} ge ${MPVREQUIRED} && echo true || echo false`
if [ ${MPVTEST} = false ];then
echo -e "\e[1;41mYour MPV version is too old.\e[0m"
echo -e "\e[1;41mKaraoke Mugen v5.0.37 will be installed.\e[0m"
MPVCHECK=false
HASH_COMMIT=ec2577cc
VERSION_TO_INSTALL=5.0.37
else
MPVCHECK=true
echo -e "\e[1;33mYour MPV version is accepted.\e[0m"
fi

#if mpv version is > 0.32, user can choose version to install
if [ ${MPVCHECK} = true ];then
PS3='Choose the version to install : '
versions=("Latest" "Next" "5.0.37" "Quit")
select fav in "${versions[@]}"; do
    case $fav in
        "Latest")
            VERSION_TO_INSTALL=$fav
            echo -e "\n\e[1;41mCurrent\e[0m\e[1;33m version will be installed.\e[0m\n\e[1;41m /!\ /\e[0m \e[1;41m You may have some bugs by installing this version\e[0m \e[41m /!\ \e[0m"
            read -n 1 -s -r -p "Press any key to continue."
            break
            ;;
        "Next")
            VERSION_TO_INSTALL=$fav
            echo -e "\n\e[1;41mNext \e[0m\e[1;33m version will be installed.\e[0m\n\e[1;41m /!\ \e[0m \e[1;41m You may have some bugs by installing this version\e[0m \e[41m /!\ \e[0m"
            read -n 1 -s -r -p "Press any key to continue."
            break
            ;;
        "5.0.37")
            VERSION_TO_INSTALL=$fav
            HASH_COMMIT=ec2577cc
            echo -e "\n\e[1;41mCurrent \e[0m\e[1;33m $fav will be installed\e[0m"
	        break
            ;;
        "Quit")
            echo -e "\e[1;41mInstallation aborted\e[0m"
            exit
            ;;
        *) echo -e "\e[1;41minvalid option $REPLY\e[0m";;
    esac
done
echo ""
fi

#moving to user's directory
cd ~

#downloading  karaoke mugen
echo -e "\n\e[44mDownloading Karaoke Mugen sources.\e[0m"
if [ -d ${KARAOKE_MUGEN_DIR} ];then
echo -e "\e[1;41mkaraokemugen-app folder already exist. Old version will be removed.\e[0m"
sudo rm -R ${KARAOKE_MUGEN_DIR}
echo -e "\e[1;33mkaraokemugen-app folder removed.\e[0m"
fi

if [ ${VERSION_TO_INSTALL} = "Latest" ];then
echo -e "\e[1;33mDownloading Latest version\e[0m"
git clone --recursive https://gitlab.com/karaokemugen/karaokemugen-app.git &>> ${LOG}
elif [ ${VERSION_TO_INSTALL} = "Next" ];then
echo -e "\e[1;33mDownloading Next version\e[0m"
git clone --recursive --branch next https://gitlab.com/karaokemugen/karaokemugen-app.git &>> ${LOG}
else
echo -e "\e[1;33mDownloading ${VERSION_TO_INSTALL} version\e[0m"
git clone --recursive https://gitlab.com/karaokemugen/karaokemugen-app.git &>> ${LOG}
cd ${KARAOKE_MUGEN_DIR}
git checkout ${HASH_COMMIT}
fi
echo -e "\e[1;32mSources successfully downloaded.\e[0m"

#Port Forwarding
echo -e "\n\e[44mPort Forwarding (80 > 1337).\e[0m\n\e[1;41mChoose \"YES\" on next screens (save IPv4/IPv6 rules) if you never installed IPTABLES\e[0m"
read -n 1 -s -r -p "Understood ! (press any key to continue)."
sudo apt install -yq iptables-persistent 
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 1337

# setting postgresql database
echo -e "\n\e[44mCreating Postegresql database, user and grant privileges.\e[0m"
sudo service postgresql start
sudo -u postgres psql -c "DROP DATABASE IF EXISTS karaokemugen_app;"
sudo -u postgres psql -c "CREATE DATABASE karaokemugen_app ENCODING 'UTF8';"
sudo -u postgres psql -c "DROP USER IF EXISTS karaokemugen_app;"
sudo -u postgres psql -c "CREATE USER karaokemugen_app WITH ENCRYPTED PASSWORD 'musubi';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE karaokemugen_app TO karaokemugen_app;"
sudo -u postgres psql -c "CREATE EXTENSION unaccent;" -d karaokemugen_app
sudo -u postgres psql -c "CREATE EXTENSION pgcrypto;" -d karaokemugen_app
echo -e "\e[1;32mDatabase successfully configured.\e[0m"

# editing package.json file (sentry/cli not supported on raspi atm)
echo ""
echo -e "\n\e[44mRemoving Sentry/cli package due to incompatibility.\e[0m"
cd ${KARAOKE_MUGEN_DIR}
sed -i '/sentry\/cli/d' package.json
echo -e "\e[1;32mPackage list updated.\e[0m"

# build karaoke mugen
echo -e "\n\e[44mBuild Karaoke Mugen.\e[0m\n\e[1;41mThis operation will take time and terminal may crash if you use wifi connexion\e[0m"
read -n 1 -s -r -p "Understood ! (press any key to continue)."
echo -e "\n\e[1;33mBuild started, please wait a moment (5-10 mins).\e[0m"
yarn gitconfig &>> ${LOG}
yarn setup &>> ${LOG}

# Editing mpv required version at launch 0.33 > 0.32
sed -i "s/MPVVersion = '>=0.33.0'/MPVVersion = '>=0.32.0'/g" ~/karaokemugen-app/src/utils/constants.ts
echo -e "\e[1;32mBuild done.\e[0m"

# creating external song folder
echo -e "\n\e[44mCreating song folders.\e[0m"
if [ ! -d ${SONG_DIR} ];then
echo -e "\e[1;33mSong folder not found, creating it\e[0m"
mkdir ${SONG_DIR}
else
echo -e "\e[1;33mSong folder found, skipping\e[0m"
fi

if [ ! -d ${SONG_DIR}/karaokes ];then
echo -e "\e[1;33mKaraoke folder not found, creating it\e[0m"
mkdir ${SONG_DIR}/karaokes
else
echo -e "\e[1;33mKaraoke folder found, skipping\e[0m"
fi

if [ ! -d ${SONG_DIR}/lyrics ];then
echo -e "\e[1;33mLyrics folder not found, creating it\e[0m"
mkdir ${SONG_DIR}/lyrics
else
echo -e "\e[1;33mLyrics folder found, skipping\e[0m"
fi

if [ ! -d ${SONG_DIR}/medias ];then
echo -e "\e[1;33mMedia folder not found, creating it\e[0m"
mkdir ${SONG_DIR}/medias
else
echo -e "\e[1;33mMedia folder found, skipping\e[0m"
fi

if [ ! -d ${SONG_DIR}/tags ];then
echo -e "\e[1;33mTags folder not found, creating it\e[0m"
mkdir ${SONG_DIR}/tags
else
echo -e "\e[1;33mTags folder found, skipping\e[0m"
fi

#creating songs folder in KM folder
if [ ! -d ${KARAOKE_MUGEN_DIR}/app ];then
echo -e "\e[1;33mApp folder not found, creating it\e[0m"
mkdir ${KARAOKE_MUGEN_DIR}/app
else
echo -e "\e[1;33mApp folder found, skipping\e[0m"
fi

if [ ! -d ${KARAOKE_MUGEN_DIR}/app/repos ];then
echo -e "\e[1;33mRepos folder not found, creating it\e[0m"
mkdir ${KARAOKE_MUGEN_DIR}/app/repos
else
echo -e "\e[1;33mRepos folder found, skipping\e[0m"
fi

if [ ! -d ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/ ];then
echo -e "\e[1;33mKara.moe folder not found, creating it\e[0m"
mkdir ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/
else
echo -e "\e[1;33mKara.moe folder found, removing it.\e[0m"
read -n 1 -s -r -p "If you have old downloads inside, please move them now in ${SONG_DIR} (press any key to continue)."
sudo rm -r ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/
mkdir ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/
fi

#Creating sym links
echo -e "\e[1;33mCreating SymLinks\e[0m"
ln -s ${SONG_DIR}/karaokes ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/karaokes
ln -s ${SONG_DIR}/lyrics ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/lyrics
ln -s ${SONG_DIR}/medias ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/medias
ln -s ${SONG_DIR}/tags ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/tags
echo -e "\e[1;32mDone.\e[0m"
echo -e "\n\e[44mSong folder will be located here ${SONG_DIR}\e[0m\n\e[1;41mPlease, keep the default values while the first start (${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/medias)\e[0m"
read -n 1 -s -r -p "Understood ! (press any key to continue)."

#Generating KM configuration
echo -e "\n\e[44mGenerating Karaoke Mugen configuration.\e[0m"
if [ ! -f "${KARAOKE_MUGEN_DIR}/config.yml" ];then
echo "
System:
 Database:
  bundledPostgresBinary: false
  database: karaokemugen_app
  host: localhost
  password: musubi
  port: 5432
  username: karaokemugen_app
" > ${KARAOKE_MUGEN_DIR}/config.yml
fi
echo -e "\e[1;32mConfiguration file generated.\e[0m"

#Check OS
#cat /etc/issue


#Desktop shortcut
echo -e "\n\e[44mCreating desktop shortcut.\e[0m"
if [ ! -f ~/Desktop/karaokeMugen.desktop ];then
echo '[Desktop Entry]
Name=Karaoke Mugen
Comment=Launch Karaoke Mugen
Icon='${MUGEN_PI_DIR}'/icon.png
Exec=lxterminal -t "Karaoke Mugen" --working-directory='${MUGEN_PI_DIR}' -e ./launch.sh
Type=Application
Encoding=UTF-8
Terminal=false
Categories=None;' > ~/Desktop/karaokeMugen.desktop
chmod u+x ~/Desktop/karaokeMugen.desktop
echo -e "\e[1;32mShortcut created.\e[0m"
echo ""
fi

#Desktop update shortcut
echo -e "\e[44mCreating update desktop shortcut.\e[0m"
if [ ! -f ~/Desktop/karaokeMugenUpdate.desktop ];then
echo '[Desktop Entry]
Name=Karaoke Mugen Update
Comment=Update Karaoke Mugen
Icon='${MUGEN_PI_DIR}'/updateicon.png
Exec=lxterminal -t "Update Karaoke Mugen" --working-directory='${MUGEN_PI_DIR}' -e ./update.sh
Type=Application
Encoding=UTF-8
Terminal=false
Categories=None;' >> ~/Desktop/karaokeMugenUpdate.desktop
chmod u+x ~/Desktop/karaokeMugenUpdate.desktop
echo -e "\e[1;32mShortcut created.\e[0m"
echo ""
fi

#Edit filemanager to avoid "open in terminal" window
echo -e "\n\e[44mEdit filemanager to avoid \"open in terminal\" window.\e[0m"
if [ ! -d ~/.config/libfm ];then
echo -e "\e[1;33mlibfm folder not found, creating it\e[0m"
mkdir ~/.config/libfm/
else
echo -e "\e[1;33mlibfm folder found, skipping.\e[0m"
fi


if [ ! -f ~/.config/libfm/libfm.conf ];then
echo -e "\e[1;33mGenerating libfm.conf\e[0m"
echo "# Configuration file for the libfm version 1.3.1.
# Autogenerated file, don't edit, your changes will be overwritten.

[config]
single_click=0
use_trash=1
confirm_del=1
confirm_trash=1
advanced_mode=0
si_unit=0
force_startup_notify=1
backup_as_hidden=1
no_usb_trash=1
no_child_non_expandable=0
show_full_names=0
only_user_templates=0
template_run_app=0
template_type_once=0
auto_selection_delay=600
drop_default_action=auto
defer_content_test=0
quick_exec=1
show_internal_volumes=0
terminal=x-terminal-emulator %s
archiver=xarchiver
thumbnail_local=1
thumbnail_max=2048
smart_desktop_autodrop=1
cutdown_menus=1
cutdown_places=1
real_expanders=1

[ui]
big_icon_size=48
small_icon_size=24
pane_icon_size=24
thumbnail_size=80
show_thumbnail=1
shadow_hidden=0

[places]
places_home=1
places_desktop=0
places_root=1
places_computer=0
places_trash=0
places_applications=0
places_network=0
places_unmounted=1
places_volmounts=1" > ~/.config/libfm/libfm.conf
else 
echo -e "\e[1;33mlibfm.conf found, updating it.\e[0m"
sed -i 's/quick_exec=0/quick_exec=1/' ~/.config/libfm/libfm.conf
fi
echo -e "\e[1;32mDone.\e[0m"

#Wallpaper
echo -e "\n\e[44mUpdating wallpaper.\e[0m"
if [ ! -d ~/.config/pcmanfm ];then
mkdir ~/.config/pcmanfm/
echo -e "\e[1;33mpcmanfm created.\e[0m"
fi

if [ ! -d ~/.config/pcmanfm/LXDE-pi ];then
mkdir ~/.config/pcmanfm/LXDE-pi
echo -e "\e[1;33mLXDE-pi created.\e[0m"
fi

echo '[*]
wallpaper_mode=crop
wallpaper_common=1
wallpaper='${MUGEN_PI_DIR}'/mugenpi.png
desktop_bg=#d6d3de
desktop_fg=#e8e8e8
desktop_shadow=#d6d3de
desktop_font=PibotoLt 12
show_wm_menu=0
sort=mtime;ascending;
show_documents=0
show_trash=1
show_mounts=1' > ~/.config/pcmanfm/LXDE-pi/desktop-items-0.conf

echo -e "\e[1;33mdesktop-items-0.conf created.\e[0m"

echo -e "\n\e[1;32mDone.\e[0m"
echo
#Finish installation
read -n 1 -s -r -p "Press any key to reboot and finish installation"
#sudo reboot
