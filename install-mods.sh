stardewpath="$HOME/.steam/steam/steamapps/common/Stardew Valley"
modspath="$stardewpath/Mods"

[ $# -eq 0 ] && echo "Usage install-mods.sh <archive1> <archive2> etc" && exit 1
[ ! -d "$stardewpath" ] && echo "ERROR: Stardew Valley is not installed" && exit 1

echo "Installing mods"
for mod in "$@"; do
  name="${mod%.*}"
  rm -r "$modspath/$name"
  mkdir "$modspath/$name"
  case "$mod" in
    *.zip) unzip -o "$mod" -d "$modspath/$name" & ;;
    *.rar) unrar x "$mod" -o "$modspath/$name" ;;
    *.7z) 7z x "$mod" "-o$modspath/$name" ;;
    *) echo "ERROR: Unsupported archive $mod"
  esac
done
wait