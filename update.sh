#!/bin/bash -e

MUGEN_PI_DIR=$PWD
KARAOKE_MUGEN_DIR=~/karaokemugen-app
SONG_DIR=~/songs-karaokemugen

#Welcome message
echo -e "\n\e[1;34mWelcome to Karaoke Mugen Installer\e[0m\n\n\e[1;33m/!\ It's recommanded to run this script under a wired connection.\nIf the installation fail, just launch the script once again\e[0m\n"

PS3='Choose the version to install : '
versions=("Latest" "Next" "5.0.37" "Quit")
select fav in "${versions[@]}"; do
    case $fav in
        "Latest")
            VERSION_TO_INSTALL=$fav
            echo -e "\n\e[1;34mCurrent version will be installed.\e[0m\n\e[1;33m/!\ You may have some bugs by installing this version\e[0m"
            read -n 1 -s -r -p "Press any key to continue."
            break
            ;;
        "Next")
            VERSION_TO_INSTALL=$fav
            echo -e "\n\e[1;34mNext version will be installed.\e[0m\n\e[1;33m/!\ You may have some bugs by installing this version\e[0m"
            read -n 1 -s -r -p "Press any key to continue."
            break
            ;;
        "5.0.37")
            VERSION_TO_INSTALL=$fav
            HASH_COMMIT=a37dbaa0
            echo "\nVersion $fav will be installed"
	          break
            ;;
        "Quit")
	    echo "Installation aborted"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done

#confirm update
echo -e "\n\e[41mOld version will be removed, please confirm your songs folders (kara.moe AND local songs) are NOT in karaokemugen-app directory.\e[0m"

PS3='Are you ready to update Karaoke Mugen ? : '
versions=("Yes" "No" "Quit")
select fav in "${versions[@]}"; do
    case $fav in
        "Yes")
	    echo "Understood, installation started"
        break
	    ;;
        "No")
	    echo "Installation aborted"
	    exit
	    ;;
	"Quit")
	    echo "Installation aborted"
	    exit
	    ;;
        *) echo "invalid option $REPLY";;
    esac
done

#moving to user's directory
cd ~

# saving KM configuration
echo -e "\e[1;34mSaving Karaoke Mugen configuration.\e[0m"
if [ -f "${KARAOKE_MUGEN_DIR}/config.yml" ];then
cp ${KARAOKE_MUGEN_DIR}/config.yml ${MUGEN_PI_DIR}/config.yml
echo -e "\e[1;32mconfig.yml file saved.\e[0m"
fi

# update system 
echo -e "\n\e[1;34mUpdating the system.\e[0m"
sudo apt update -q && sudo apt upgrade -y -q
echo -e "\e[1;32mSystem updated.\e[0m"
echo ""

#downloading  karaoke mugen
echo -e "\e[1;34mDownloading Karaoke Mugen sources.\e[0m"
if [ -d "${KARAOKE_MUGEN_DIR}" ];then
echo -e "\e[41mkaraokemugen-app folder already exist. Old version will be removed.\e[0m"
sudo rm -R ${KARAOKE_MUGEN_DIR}
echo -e "\e[1;33mkaraokemugen-app folder removed.\e[0m"
fi

if [ "${VERSION_TO_INSTALL}" = "Lastest" ];then
echo "Downloading last version"
git clone --recursive https://lab.shelter.moe/karaokemugen/karaokemugen-app.git
elif [ "${VERSION_TO_INSTALL}" = "Next" ];then
git clone --recursive --branch next https://lab.shelter.moe/karaokemugen/karaokemugen-app.git
else
echo "Downloading version ${VERSION_TO_INSTALL}"
git clone --recursive https://lab.shelter.moe/karaokemugen/karaokemugen-app.git
cd ${KARAOKE_MUGEN_DIR}
git checkout ${HASH_COMMIT}
fi
echo -e "\e[1;32mSources successfully downloaded.\e[0m"
echo ""

# editing package.json file (sentry/cli not supported on raspi atm)
echo -e "\n\e[1;34mRemoving Sentry/cli package due to incompatibility.\e[0m"
cd ${KARAOKE_MUGEN_DIR}
sed -i '/sentry\/cli/d' package.json
echo -e "\e[1;32mPackage list updated.\e[0m"

# build karaoke mugen
echo -e "\n\e[1;34mBuilding Karaoke Mugen.\e[0m\n\e[1;41mThis operation will take time and terminal may crash if you use wifi connexion\e[0m"
read -n 1 -s -r -p "Press any key to continue."
yarn gitconfig
yarn setup
echo -e "\e[1;34mBuild done.\e[0m"

# creating external song folder
echo -e "\n\e[1;34mCreating song folder.\e[0m"
if [ ! -d "${SONG_DIR}" ];then
echo -e "\e[1;33mSong folder not found, creating it\e[0m"
mkdir ${SONG_DIR}
fi

if [ ! -d "${SONG_DIR}/karaokes" ];then
echo -e "\e[1;33mKaraoke folder not found, creating it\e[0m"
mkdir ${SONG_DIR}/karaokes
fi

if [ ! -d "${SONG_DIR}/lyrics" ];then
echo -e "\e[1;33mLyrics folder not found, creating it\e[0m"
mkdir ${SONG_DIR}/lyrics
fi

if [ ! -d "${SONG_DIR}/medias" ];then
echo -e "\e[1;33mMedia folder not found, creating it\e[0m"
mkdir ${SONG_DIR}/medias
fi

if [ ! -d "${SONG_DIR}/tags" ];then
echo -e "\e[1;33mTags folder not found, creating it\e[0m"
mkdir ${SONG_DIR}/tags
fi

#creating songs folder in KM folder
if [ ! -d "${KARAOKE_MUGEN_DIR}/app" ];then
echo -e "\e[1;33mApp folder not found, creating it\e[0m"
mkdir ${KARAOKE_MUGEN_DIR}/app
fi

if [ ! -d "${KARAOKE_MUGEN_DIR}/app/repos" ];then
echo -e "\e[1;33mRepos folder not found, creating it\e[0m"
mkdir ${KARAOKE_MUGEN_DIR}/app/repos
fi

if [ ! -d "${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/" ];then
echo -e "\e[1;33mKara.moe folder not found, creating it\e[0m"
mkdir ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/
else
echo -e "\e[1;33mKara.moe folder found, removing it.\e[0m"
sudo rm -r ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/
mkdir ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/
fi

#Creating sym links
ln -s ${SONG_DIR}/karaokes ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/karaokes
ln -s ${SONG_DIR}/lyrics ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/lyrics
ln -s ${SONG_DIR}/medias ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/medias
ln -s ${SONG_DIR}/tags ${KARAOKE_MUGEN_DIR}/app/repos/kara.moe/tags
echo -e "\e[1;32mDone.\e[0m"

# restoring KM configuration
echo -e "\e[1;34mRestoring Karaoke Mugen configuration.\e[0m"
if [ -f "${KARAOKE_MUGEN_DIR}/config.yml" ];then
sudo rm ${KARAOKE_MUGEN_DIR}/config.yml
cp ${MUGEN_PI_DIR}/config.yml ${KARAOKE_MUGEN_DIR}/config.yml
else
cp ${MUGEN_PI_DIR}/config.yml ${KARAOKE_MUGEN_DIR}/config.yml
fi
sudo rm ${MUGEN_PI_DIR}/config.yml
echo -e "\e[1;33mconfig.yml file restored.\e[0m"
echo ""

#Finish installation
echo -e "\e[1;32mUpdate done.\e[0m"
read -n 1 -s -r -p "Press any key to finish update"

