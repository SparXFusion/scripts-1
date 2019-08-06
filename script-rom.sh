#!/bin/bash
#
# Copyright (C) 2019 Carlos Arriaga <carlosarriagacm@gmail.com>
#

# Export idk
export KBUILD_BUILD_USER="TheStrechh"
export KBUILD_BUILD_HOST="legacyhost"
export ALLOW_MISSING_DEPENDENCIES=true

# CCACHE UMMM!!! Cooks my builds fast
echo -e "CCACHE is enabled for this build"
export USE_CCACHE=1
export CCACHE_DIR=/root/ccache
prebuilts/misc/linux-x86/ccache/ccache -M 30G

# Clean build
echo -e "Cleaned SHIT"
make clean && make clobber

# Build ROM
echo -e "BUILDING ROM :D"
. build/envsetup.sh
lunch lineage_lavender-userdebug
make bacon -j8
