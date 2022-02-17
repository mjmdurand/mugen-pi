#!/bin/bash

CHOICES=$(whiptail --separate-output --checklist "Choose componements to install" 15 75 5 \
  "Core" "The KM app with all dependancies" ON \
  "Launch" "Launch KM with a desktop shortcut" ON \
  "Update" "Update KM with a desktop shortcut" ON \
  "Wallpaper" "Change the wallpaper to a KM one" ON \
  "Filemanager" "Hide the \"open in terminal\" window " ON  3>&1 1>&2 2>&3)

if [ -z "$CHOICES" ]; then
  echo "No option was selected (user hit Cancel or unselected all options)"
else
  for CHOICE in $CHOICES; do
    case "$CHOICE" in
    "Core")
      echo "Option 1 was selected"
      ;;
    "Launch")
      echo "Option 2 was selected"
      ;;
    "Update")
      echo "Option 3 was selected"
      ;;
    "Wallpaper")
      echo "Option 4 was selected"
      ;;
    "Filemanager")
      echo "Option 5 was selected"
      ;;
    *)
      echo "Unsupported item $CHOICE!" >&2
      exit 1
      ;;
    esac
  done
fi