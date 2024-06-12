#!/bin/bash

# check if the script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo or as root. (sudo ./apptomenu.sh)"
  exit 1
fi

# get the home directory
user_home=$(eval echo ~${SUDO_USER})

# whats the path to the AppImage
read -p "What's the path to your appimage? " appimage_path

# version of the application?
read -p "What's the version of your application? (optional, ENTER to skip) " version

# whats the the tooltip/description
read -p "What do you want your tooltip/description to be? (optional, ENTER to skip) " tooltip

# whats the name of the icon?
read -p "What's the name of the icon you want to be used? (optional, ENTER to skip) " icon_name

# what category?
read -p "What category do you want it to be in? (optional, ENTER to skip) " category

# asks if the user wants to run your thing to run from a terminal
read -p "Do you want it to run from a terminal? y/n " run_terminal

# translate y/n to true/false, only for better UX, not really important code.
if [[ "$run_terminal" == "y" ]]; then
    terminal_value="true"
else
    terminal_value="false"
fi

# make the .desktop file 
desktop_content="[Desktop Entry]
Type=Application
Version=${version}
Name=$(basename $appimage_path .AppImage)
Comment=${tooltip}
Exec=${appimage_path}
Icon=${icon_name}
Terminal=${terminal_value}
Categories=${category}
"

# figure out where to save the .desktop file
desktop_file_path="$user_home/.local/share/applications/$(basename $appimage_path .AppImage).desktop"

# make /applications if it doesnt exist already
mkdir -p "$user_home/.local/share/applications"

# save the .desktop file
echo "$desktop_content" > "$desktop_file_path"

# say where the .desktop file was saved
echo ".desktop saved to: $desktop_file_path"

# update the desktop database
update-desktop-database "$user_home/.local/share/applications"

echo "Done!"

