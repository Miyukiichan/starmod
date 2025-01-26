#!/bin/bash

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -g|--game)
      game="$2"
      shift 2
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

[[ -z $game ]] && echo "Please provide the game url path using -g"

mods_found=false
echo "Opening mod pages in browser"
for file in $PARAMS; do
  modfile="$(realpath $file)"
  [ ! -f "$modfile" ] && echo "File $modfile not found" && exit 1
  while IFS= read -r line; do 
    line="$(echo $line | sed 's/\#.*//' | xargs)" # Remove comments
    name=$(echo $line | awk -F "\"*,\"*" '{print $1}')
    mod_id=$(echo $line | awk -F "\"*,\"*" '{print $2}')
    file_id=$(echo $line | awk -F "\"*,\"*" '{print $3}')
    [[ -z $name || -z $mod_id || -z $file_id ]] && continue
    mods_found=true
    url="https://www.nexusmods.com/$game/mods/$mod_id/?tab=files&file_id=$file_id"
    xdg-open $url
  done < $modfile
done
[ $mods_found ] || echo "ERROR: No mods found in provided file" || exit 1
