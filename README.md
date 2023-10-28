# starmod

Provides a series of scripts designed to make modding Stardew Valley easier on Linux.
Suggested use would be to run starmod.sh and then install-mods.sh when ready.

## starmod.sh

The two main features are:

1. Automatically install SMAPI
2. Open the provided list of mods in the browser

The latter feature is required to work this way for non-premium Nexus accounts since Nexus requires you to download the mod manually from the site.

### Usage

```sh
starmod.sh *.csv
```

### Mod List Format

The mod list is a CSV with no header with the following columns:

1. Mod Name - note this doesn't do anything but makes it easier to read/edit the mods in the file
2. Mod ID
3. File ID

## install-mods.sh

Best used from the directory containing all the downloaded mods with the following command

```sh
install-mods.sh ./*
```
