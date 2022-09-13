#!/bin/bash

### Credit to the Authors at https://rentry.org/CFWGuides
### Script created by Fraxalotl

# -------------------------------------------

### Install jq if not already installed
if [[ "$OSTYPE" == "msys" ]]; then
  # Windows
  @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
  chocolatey install jq
elif [[ "$OSTYpe" == "darwin" ]]; then
  # MacOS
  brew install jq
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # linux
  sudo apt-get install jq
fi
  
### Fetch latest Hekate + Nyx from https://github.com/CTCaer/hekate/releases/latest/
echo Downloading Hekate...
curl -sL https://api.github.com/repos/CTCaer/hekate/tags \
  | jq -r '.[0].zipball_url' \
  | xargs -I {} curl -sL {} -o hekate.zip
echo Done!

### Fetch latest atmosphere from https://github.com/Atmosphere-NX/Atmosphere/releases/latest
curl -sL https://api.github.com/repos/Atmosphere-NX/Atmosphere/tags \
  | jq -r '.[0].zipball_url' \
  | xargs -I {} curl -sL {} -o atmosphere.zip
echo Done!

### Fetch latest SigPatches.zip from https://github.com/ITotalJustice/patches/releases/latest
echo Downloading Sigpatches...
curl -sL https://jits.cc/patches -o sigpatches.zip;
echo Done!

# -------------------------------------------

### Unzip Downloaded Packages

echo Unzipping Zips...
unzip -u hekate.zip
unzip -u atomsphere.zip
unzip -u sigpatches.zip
echo Done!

### Cleanup Downloaded Zips

echo Cleaning up...
rm hekate.zip
rm atmosphere.zip
rm sigpatches.zip
echo Done!


### Place fusee.bin in /bootloader/payloads/
if [[ "$OSTYPE" == "msys" ]]; then
  move fusee.bin /bootloader/payloads
else
  mv fusee.bin /bootloader/payloads

# -------------------------------------------

### Write hekate_ipl.ini in /bootloader/ directory
echo Writing hekate_ipl.ini in /bootloader/ directory...
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
echo Done!

# -------------------------------------------

### write exosphere.ini in root of SD Card
echo Writing exosphere.ini in root of SD card...
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
echo Done!

# -------------------------------------------

### Write default.txt in /atmosphere/hosts
echo Writing default.txt in /atmosphere/hosts
mkdir -p /atmosphere/hosts
cat > /atmosphere/hosts/default.txt << ENDOFFILE
# Block Nintendo Servers
127.0.0.1 *nintendo.*
127.0.0.1 *nintendo-europe.com
127.0.0.1 *nintendoswitch.*
95.216.149.205 *conntest.nintendowifi.net
95.216.149.205 *ctest.cdn.nintendo.net
ENDOFFILE
echo Done!

# -------------------------------------------

echo Your Switch SD card is prepared!
