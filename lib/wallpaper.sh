#!/bin/bash -e
#Wallpaper
echo -e "\n\e[1;44mUpdating wallpaper.\e[0m"
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
wallpaper='${MUGEN_PI_DIR}'/img/mugenpi.png
desktop_bg=#d6d3de
desktop_fg=#e8e8e8
desktop_shadow=#d6d3de
desktop_font=PibotoLt 12
show_wm_menu=0
sort=mtime;ascending;
show_documents=0
show_trash=1
show_mounts=1' > ~/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
echo -e "\e[1;32mdesktop-items-0.conf created.\e[0m"

