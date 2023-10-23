#!/bin/bash

stardewpath="$HOME/.steam/steam/steamapps/common/Stardew Valley"
modspath="$stardewpath/Mods"
smapi="https://github.com/Pathoschild/SMAPI/releases/latest/download/SMAPI-3.18.6-installer.zip"

# Setup, param checking and user confirmation
[ $# -eq 0 ] && echo "Usage starmod.sh <modfile1> <modfile2> etc" && exit 1
[ ! -d "$stardewpath" ] && echo "ERROR: Stardew Valley is not installed" && exit 1
echo "WARNING: This process will delete your stardew valley mods folder and open all the listed mods in your browser at once. Do you wish to continue? (y/n)"
read confirmation
[[ $confirmation == 'y' || $confirmation == 'Y' ]] || exit 1
rm -r starmod-data
mkdir starmod-data || exit 1
cd starmod-data
mkdir Mods || echo "ERROR: Failed create Mods folder" || exit 1
rm -r "$modspath"

# Downlaod and run SMAPI first - this should automatically create the mods directory, if not then create it manually
echo "Downloading SMAPI"
wget $smapi --user-agent="Mozilla" -o log.txt -O SMAPI.zip || exit 1
unzip -q SMAPI.zip -d SMAPI || exit 1
 # Exact folder name changes with version so need to determine this
smapi_folder="$(ls SMAPI)"
cd "SMAPI/$smapi_folder"
# Can't use the linux install script since that does not pass args to the installer - need to run manually
./internal/linux/SMAPI.Installer --no-prompt --install --game-path "$stardewpath" || exit 1
cd ../..
[ -d "$modspath" ] || mkdir "$modspath" 
[ -d "$modspath" ] || echo "ERROR: Mod path does not exist" || exit 1
rm -r SMAPI || echo "ERROR: Failed to remove SMAPI" || exit 1
rm SMAPI.zip || echo "ERROR: Failed to remove SMAPI.zip" || exit 1

# Build URLs and open in default browser
mods_found=false
echo "Opening mod pages in browser"
cd .. # Need to go back to the original location to deal with relative paths
for file in "$@"; do
  modfile="$(realpath $file)"
  [ ! -f "$modfile" ] && echo "File $modfile not found" && exit 1
  while IFS= read -r line; do 
    name=$(echo $line | awk -F "\"*,\"*" '{print $1}')
    mod_id=$(echo $line | awk -F "\"*,\"*" '{print $2}')
    file_id=$(echo $line | awk -F "\"*,\"*" '{print $3}')
    [[ -z $name || -z $mod_id || -z $file_id ]] && continue
    mods_found=true
    url="https://www.nexusmods.com/stardewvalley/mods/$mod_id/?tab=files&file_id=$file_id"
    xdg-open $url
  done < $modfile
done
cd starmod-data

[ $mods_found ] || echo "ERROR: No mods found in provided file" || exit 1

echo "Please download the zip files and place them in $(pwd)/Mods"
echo "Once this has been done, press enter to install the downloaded mods"
read

[ -z "$(ls Mods)" ] && echo "ERROR: No mods found in folder" && exit 1

echo "Installing mods"
for mod in Mods/*; do
  # Assume that the zip file contains a directory at the root - nexus mods tend to do that
  unzip -q -o "$mod" -d "$modspath" &
done
wait

echo "Process finished"
