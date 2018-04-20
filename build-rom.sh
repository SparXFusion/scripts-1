#!/bin/bash
#
# Copyright (C) 2018 Carlos Arriaga <carlosarriagacm@gmail.com>
#
# Usage: ./build-rom.sh <DEVICE>
#

device="$1"

# idk only exports
export KBUILD_BUILD_USER="TheStrechh"
export KBUILD_BUILD_HOST="legacyhost"
export ALLOW_MISSING_DEPENDENCIES=true

# Make a clean build
make clean && make clobber

# Set CCACHE
export USE_CCACHE=1
export CCACHE_DIR=/home/carlos/ccache/rom_name
prebuilts/misc/linux-x86/ccache/ccache -M 50G

# Compile the build
. build/envsetup.sh
lunch lineage_$device-userdebug
time mka bacon -j8
