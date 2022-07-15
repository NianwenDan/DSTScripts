#!/bin/bash
## 获取今天的 yyyy-MM-dd_HH.MM.SS
TODAY=$(date "+%Y-%m-%d_%H.%M.%S")
listCurrentRunningScreen=$(screen -ls)

# Check DST Server status
isContainName2=$(echo $listCurrentRunningScreen | grep "DST_MASTER")
if [[ $isContainName2 != "" ]];
then
        echo "Don't Starve Together Server(MASTER) is running"
        echo "Update Program Stopped!!!"
else
        echo "Game is not running"
        # Apply update.
        ~/steamcmd/steamcmd.sh +login anonymous +force_install_dir ~/dst +app_update 343050 validate +quit
        # Save current version number.
        ~/script/autoUpdate/DST_getCurrentVersion.sh > ~/script/autoUpdate/currentVersion.txt
        # 成功更新推送服务（可选）
        # https://push.example.com/
fi
