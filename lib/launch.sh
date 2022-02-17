#!/bin/bash -e

#Desktop launch shortcut
echo -e "\n\e[1;44mCreating launch desktop shortcut.\e[0m"
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
echo -e "\e[1;32mLaunch shortcut created.\e[0m"
else
echo -e "\e[1;33mLaunch shortcut already exists, skipping.\e[0m"
fi