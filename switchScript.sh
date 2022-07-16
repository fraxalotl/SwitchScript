#!/bin/bash

### Credit to the Authors at https://rentry.org/CFWGuides
### Script created by Fraxalotl

# -------------------------------------------

### Install jq if not already installed
brew install jq

### Fetch latest Hekate + Nyx from https://github.com/CTCaer/hekate/releases/latest/
curl -s https://api.github.com/repos/CTCaer/hekate/releases/latest | jq -r ".assets[] | select(.name | te
st(\"hekate_ctcaer\")) | .browser_download_url"

### Fetch latest atmosphere + fusee.bin from https://github.com/Atmosphere-NX/Atmosphere/releases/latest
curl -s https://api.github.com/repos/Atmosphere-NX/Atmosphere/releases/latest | jq -r ".assets[] | select(.name | te
st(\"hekate_ctcaer\")) | .browser_download_url"

### Fetch latest SigPatches.zip from https://github.com/ITotalJustice/patches/releases/latest
curl -s https://api.github.com/repos/ITotalJustice/patches/releases/latest | jq -r ".assets[] | select(.name | te
st(\"hekate_ctcaer\")) | .browser_download_url"

# -------------------------------------------

### Place fusee.bin in /bootloader/payloads/
mv fusee.bin /bootloader/payloads

# -------------------------------------------

### Write hekate_ipl.ini in /bootloader/ directory
mkdir -p /bootloader
cat > /bootloader/hekate_ipl.ini << ENDOFFILE
[config]
autoboot=0
autoboot_list=0
bootwait=3
backlight=100
autohosoff=0
autonogc=1
updater2p=0
bootprotect=0

[Atmosphere CFW]
payload=bootloader/payloads/fusee.bin
icon=bootloader/res/icon_payload.bmp

[Stock SysNAND]
fss0=atmosphere/package3
stock=1
emummc_force_disable=1
icon=bootloader/res/icon_switch.bmp
ENDOFFILE

# -------------------------------------------

### write exosphere.ini in root of SD Card
cat > /exosphere.ini << ENDOFFILE
[exosphere]
debugmode=1
debugmode_user=0
disable_user_exception_handlers=0
enable_user_pmu_access=0
blank_prodinfo_sysmmc=0
blank_prodinfo_emummc=1
allow_writing_to_cal_sysmmc=0
log_port=0
log_baud_rate=115200
log_inverted=0
ENDOFFILE

# -------------------------------------------

### Write default.txt in /atmosphere/hosts
mkdir -p /atmosphere/hosts
cat > /atmosphere/hosts/default.txt << ENDOFFILE
# Block Nintendo Servers
127.0.0.1 *nintendo.*
127.0.0.1 *nintendo-europe.com
127.0.0.1 *nintendoswitch.*
95.216.149.205 *conntest.nintendowifi.net
95.216.149.205 *ctest.cdn.nintendo.net
ENDOFFILE

# -------------------------------------------
