#!/bin/bash -e

CUSTOM_SONG_DIR=$(whiptail --title "Karaoke Mugen installation" --inputbox "Please the path you want to use" 10 75 ${SONG_DIR} 3>&1 1>&2 2>&3)
SONG_DIR=CUSTOM_SONG_DIR


# creating external song folder
echo -e "\n\e[1;44mCreating song folders.\e[0m"
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