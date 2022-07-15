#!/bin/bash

LATESTBUILD=$(~/script/autoUpdate/DST_getCurrentVersion.sh)
INSTALLEDBUILD=$(cat ~/script/autoUpdate/currentVersion.txt)

if [ $LATESTBUILD == $INSTALLEDBUILD ] ; then
        echo "UpTodate! Current buildID $INSTALLEDBUILD"
else
        echo "Current build: $INSTALLEDBUILD, SteamBuild: $LATESTBUILD"
        echo "Updating....."
	~/script/autoUpdate/DST_applyUpdate.sh
fi
