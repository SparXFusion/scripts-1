#!/bin/bash
#
# Copyright (C) 2018 Carlos Arriaga <carlosarriagacm@gmail.com>
#
# Usage: ./build-rom.sh
#
rom=lineage # The rom name
username=prada # Your user name

# Export idk
export KBUILD_BUILD_USER="TheStrechh"
export KBUILD_BUILD_HOST="legacyhost"
export ALLOW_MISSING_DEPENDENCIES=true

# CCACHE UMMM!!! Cooks my builds fast
echo -e "CCACHE is enabled for this build"
export USE_CCACHE=1
export CCACHE_DIR=/home/$username/ccache/$rom
prebuilts/misc/linux-x86/ccache/ccache -M 50G

# Clean build
echo -e "Cleaned SHIT"
make clean && make clobber

# Build ROM
echo -e "BUILDING ROM :D"
. build/envsetup.sh
lunch lineage_kenzo-userdebug
make bacon -j8
