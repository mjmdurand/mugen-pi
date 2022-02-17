#!/bin/bash -e
#Desktop update shortcut
echo -e "\n\e[1;44mCreating update desktop shortcut.\e[0m"
if [ ! -f ~/Desktop/karaokeMugenUpdate.desktop ];then
echo '[Desktop Entry]
Name=Karaoke Mugen Update
Comment=Update Karaoke Mugen
Icon='${MUGEN_PI_DIR}'/img/updateicon.png
Exec=lxterminal -t "Update Karaoke Mugen" --working-directory='${MUGEN_PI_DIR}' -e ./update.sh
Type=Application
Encoding=UTF-8
Terminal=false
Categories=None;' >> ~/Desktop/karaokeMugenUpdate.desktop
chmod u+x ~/Desktop/karaokeMugenUpdate.desktop
echo -e "\e[1;32mUpdate shortcut created.\e[0m"
else
echo -e "\e[1;33mUpdate shortcut already exists, skipping.\e[0m"
fi