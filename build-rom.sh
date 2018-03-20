#!/bin/bash
#
# Copyright (C) 2018 Carlos Arriaga <carlosarriagacm@gmail.com>
#
# Usage: ./build-rom.sh <DEVICE>
#
# red = errors, cyan = warnings, green = confirmations, blue = informational
# plain for generic text, bold for titles, reset flag at each end of line
# plain blue should not be used for readability reasons - use plain cyan instead
CLR_RST=$(tput sgr0)                        ## reset flag
CLR_CYA=$CLR_RST$(tput setaf 6)             #  cyan, plain
CLR_BLD=$(tput bold)                        ## bold flag
CLR_BLD_CYA=$CLR_RST$CLR_BLD$(tput setaf 6) #  cyan, bold

device="$1"

# Pick the default thread count (allow overrides from the environment)
if [ -z "$THREADS" ]; then
        if [ "$(uname -s)" = 'Darwin' ]; then
                export THREADS=$(sysctl -n machdep.cpu.core_count)
        else
                export THREADS=$(cat /proc/cpuinfo | grep '^processor' | wc -l)
        fi
fi

# idk only exports
export KBUILD_BUILD_USER="CarlosArriaga"
export KBUILD_BUILD_HOST="EroticHosting"
export ALLOW_MISSING_DEPENDENCIES=true

# Make a clean build, building dirty after you have had jack issues may result in a failed build
make clean && make clobber

# Set CCACHE
export USE_CCACHE=1
export CCACHE_DIR=/root/ccache/lineage
prebuilts/misc/linux-x86/ccache/ccache -M 80G

# FuckingJack
./prebuilts/sdk/tools/jack-admin kill-server
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx10g"
./prebuilts/sdk/tools/jack-admin start-server
export LANGUAGE=C

# Check the starting time (of the real build process)
TIME_START=$(date +%s.%N)

# Friendly logging to tell the user everything is working fine is always nice
echo -e "${CLR_CYA}Start time: $(date)${CLR_RST}"
echo -e ""

# Compile the build
. build/envsetup.sh
lunch lineage_$device-userdebug
make bacon -j32

# Check the finishing time
TIME_END=$(date +%s.%N)

# Log those times at the end as a fun fact of the day
echo -e "${CLR_CYA}Total time elapsed:${CLR_RST} ${CLR_CYA}$(echo "($TIME_END - $TIME_START) / 60" | bc) minutes ($(echo "$TIME_END - $TIME_START" | bc) seconds)${CLR_RST}"
echo -e ""
