#!/bin/bash -e
# update system and install softwares
echo -e "\e[1;44mUpdating the system.\e[0m"
sudo apt update -q &> ${LOG} && sudo apt upgrade -yq &> ${LOG}
echo -e "\e[1;32mSystem updated.\e[0m"

echo -e "\n\e[1;44mInstalling required software.\e[0m"
# adding nodejs 14.x repositories
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash - &>> ${LOG}
sudo apt install -yq curl nodejs mpv ffmpeg postgresql libpq-dev postgresql-client postgresql-client-common git &>> ${LOG}
sudo npm install -g yarn &>> ${LOG}
sudo apt autoremove -yq &>> ${LOG}
echo -e "\e[1;32mRequired software installation done.\e[0m"

#checking mpv version
echo -e "\n\e[1;44mCheking MPV version.\e[0m"
MPVVERS=`dpkg -s mpv | grep Version | cut -c10-`
MPVTEST=`dpkg --compare-versions ${MPVVERS} ge ${MPVREQUIRED} && echo true || echo false`
if [ ${MPVTEST} = false ];then
echo -e "\e[1;31mYour MPV version is too old.\e[0m"
echo -e "\e[1;33mKaraoke Mugen v5.0.37 will be installed.\e[0m"
MPVCHECK=false
HASH_COMMIT=ec2577cc
VERSION_TO_INSTALL=5.0.37
else
MPVCHECK=true
echo -e "\e[1;32mYour MPV version is accepted.\e[0m"
fi

#if mpv version is > 0.32, user can choose version to install
echo -e "\n\e[1;44mSelect Karaoke Mugen version.\e[0m"
if [ ${MPVCHECK} = true ];then
    OPTION=$(whiptail --title "Karaoke Mugen installation" --menu "Choose the version you want to intall" 15 60 4 \
    "1" "Latest" \
    "2" "Next" \
    "3" "5.0.37" 3>&1 1>&2 2>&3)
    
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        case $OPTION in
            1)
                VERSION_TO_INSTALL="Latest"
                echo -e "\n\e[1;33mLatest\e[0m\e[33m version will be installed.\e[0m\n\e[1;41m /!\ /\e[0m \e[1;41m You may have some bugs by installing this version\e[0m \e[1;41m /!\ \e[0m"
                ;;
            2)
                VERSION_TO_INSTALL="Next"
                echo -e "\n\e[1;33mNext\e[0m\e[33m version will be installed.\e[0m\n\e[1;41m /!\ /\e[0m \e[1;41m You may have some bugs by installing this version\e[0m \e[1;41m /!\ \e[0m"
                ;;
            3)
                VERSION_TO_INSTALL="5.0.37"
                HASH_COMMIT=ec2577cc
                echo -e "\n\e[1;33mVersion 5.0.37\e[0m\e[33m will be installed\e[0m"
                ;;
            *)
                echo -e "\n\e[1;33mCurrent\e[0m\e[33m version will be installed.\e[0m\n\e[1;41m /!\ /\e[0m \e[1;41m You may have some bugs by installing this version\e[0m \e[1;41m /!\ \e[0m"
                ;;
        esac
    fi
    echo ""
fi

#moving to user's directory
cd ~

#downloading  karaoke mugen
echo -e "\n\e[1;44mDownloading Karaoke Mugen sources.\e[0m"
if [ -d ${KARAOKE_MUGEN_DIR} ];then
echo -e "\e[1;31mkaraokemugen-app folder already exist. Old version will be removed.\e[0m"
sudo rm -R ${KARAOKE_MUGEN_DIR}
echo -e "\e[1;33mkaraokemugen-app folder removed.\e[0m"
fi

if [ ${VERSION_TO_INSTALL} = "Latest" ];then
echo -e "\e[1;33mDownloading Latest version\e[0m"
git clone --recursive https://gitlab.com/karaokemugen/karaokemugen-app.git &>> ${LOG} &
{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.3
        echo $i
    done
} | whiptail --title "Karaoke Mugen installation" --gauge "Downloading Karaoke Mugen" 8 78 0
wait -n
elif [ ${VERSION_TO_INSTALL} = "Next" ];then
echo -e "\e[1;33mDownloading Next version\e[0m"
git clone --recursive --branch next https://gitlab.com/karaokemugen/karaokemugen-app.git &>> ${LOG} &
{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.3
        echo $i
    done
} | whiptail --title "Karaoke Mugen installation" --gauge "Downloading Karaoke Mugen" 8 78 0
wait -n
else
echo -e "\e[1;33mDownloading ${VERSION_TO_INSTALL} version\e[0m"
git clone --recursive https://gitlab.com/karaokemugen/karaokemugen-app.git &>> ${LOG} &
{
    for ((i = 0 ; i <= 100 ; i+=1)); do
        sleep 0.3
        echo $i
    done
} | whiptail --title "Karaoke Mugen installation" --gauge "Downloading Karaoke Mugen" 8 78 0
wait -n
cd ${KARAOKE_MUGEN_DIR}
git checkout ${HASH_COMMIT}
fi
echo -e "\e[1;32mSources successfully downloaded.\e[0m"

# setting postgresql database
echo -e "\n\e[1;44mCreating Postegresql database, user and grant privileges.\e[0m"
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
echo -e "\n\e[1;44mRemoving Sentry/cli package due to incompatibility.\e[0m"
cd ${KARAOKE_MUGEN_DIR}
sed -i '/sentry\/cli/d' package.json
echo -e "\e[1;32mPackage list updated.\e[0m"

# build karaoke mugen
echo -e "\n\e[1;44mBuild Karaoke Mugen.\e[0m\n\e[1;41mThis operation will take time and terminal may crash if you use wifi connexion\e[0m"
echo -e "\n\e[1;33mBuild started, please wait a moment (10-15 mins).\e[0m"
yarn gitconfig &>> ${LOG}

# Start yarn setup and send it to the background.
(yarn setup ; sudo pkill node) &>> ${LOG} &
# Keep checking if the process is running. And keep a count.
{
        i="0"
        while (true)
        do
            proc=$(ps aux | grep -v grep | grep -e "node")
            if [[ "$proc" == "" ]]; then break; fi
            # Sleep for a longer period if the build is long
            sleep 6
            echo $i
            i=$(expr $i + 1)
        done
        # If it is done then display 100%
        echo 100
        # Give it some time to display the progress to the user.
        sleep 2
} | whiptail --title "Karaoke Mugen installation" --gauge "Building FrontEnd and BackEnd" 8 78 0




# Editing mpv required version at launch 0.33 > 0.32
sed -i "s/MPVVersion = '>=0.33.0'/MPVVersion = '>=0.32.0'/g" ~/karaokemugen-app/src/utils/constants.ts
echo -e "\e[1;32mBuild done.\e[0m"

#Generating KM configuration
echo -e "\n\e[1;44mGenerating Karaoke Mugen configuration.\e[0m"
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