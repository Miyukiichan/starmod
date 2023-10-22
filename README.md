# starmod

This script is designed to make modding Stardew Valley easier on Linux.

The two main features are:

1. Automatically install SMAPI
2. Open the provided list of mods in the browser and automatically install them once downloaded

The latter feature is required to work this way for non-premium Nexus accounts since Nexus requires you to download the mod manually from the site.
The actual installation is then handled by the script.

## Usage

```sh
starmod.sh mods.csv
```

## Mod List Format

The mod list is a CSV with no header with the following columns:

1. Mod Name - note this doesn't do anything but makes it easier to read/edit the mods in the file
2. Mod ID
3. File ID
