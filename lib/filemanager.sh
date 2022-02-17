#!/bin/bash -e

#Edit filemanager to avoid "open in terminal" window
echo -e "\n\e[1;44mEdit filemanager to avoid \"open in terminal\" window.\e[0m"
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