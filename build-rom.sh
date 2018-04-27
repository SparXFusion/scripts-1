#!/bin/bash
#
# Copyright (C) 2018 Carlos Arriaga <carlosarriagacm@gmail.com>
#
# Usage: ./build-rom.sh
#
rom=aoscp
username=prada

# Colors makes things beautiful
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
blu=$(tput setaf 4)             #  blue
cya=$(tput setaf 6)             #  cyan
txtrst=$(tput sgr0)             #  Reset

# CCACHE UMMM!!! Cooks my builds fast
echo -e ${blu}"CCACHE is enabled for this build"${txtrst}
export USE_CCACHE=1
export CCACHE_DIR=/home/$username/ccache/$rom
prebuilts/misc/linux-x86/ccache/ccache -M 50G

# Clean build
make clean && make clobber

# Build ROM
. build/envsetup.sh
lunch $rom_kenzo-userdebug
make bacon -j8
