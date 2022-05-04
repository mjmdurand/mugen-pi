#!/bin/bash -e
#Desktop launch shortcut
echo -e "\n\e[1;44mCreating launch desktop shortcut.\e[0m"
if [ ! -f ${DESKTOP_PATH}/karaokeMugen.desktop ];then
echo '[Desktop Entry]
Name=Karaoke Mugen
Comment=Launch Karaoke Mugen
Icon='${MUGEN_PI_DIR}'/img/icon.png
Exec=gnome-terminal -t "Karaoke Mugen" --working-directory='${MUGEN_PI_DIR}' -e ./launch.sh
Type=Application
Encoding=UTF-8
Terminal=false
Categories=None;' > ${DESKTOP_PATH}/karaokeMugen.desktop
chmod u+x ${DESKTOP_PATH}/karaokeMugen.desktop
echo -e "\e[1;32mLaunch shortcut created.\e[0m"
else
echo -e "\e[1;33mLaunch shortcut already exists, skipping.\e[0m"
fi
