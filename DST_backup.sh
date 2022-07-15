#!/bin/bash
##关闭游戏服务
gameRunning=$(~/script/shutdownDST.sh)
isGameRunning=$(echo $gameRunning | grep "is running, shutting down")
if [[ $isGameRunning != "" ]];
then
echo "Game is shutting down, waiting 30 seconds to backup."
sleep 30s
fi
########################
##### Backup Start #####
########################
## 获取今天的 yyyy-MM-dd
TODAY=$(date "+%Y-%m-%d_%H.%M.%S")
## 数据库打包备份
mkdir -p /tmp/backup
cd /tmp/backup
## 根目录打包压缩
cd ~/.klei/DoNotStarveTogether
zip -r /tmp/backup/DSTBackup_${TODAY}.zip ./MyDediServer
tar -cf /tmp/backup/DSTBackup_${TODAY}.tar ./MyDediServer
## 将文件传送到云端
sudo /usr/bin/rclone copy "/tmp/backup/DSTBackup_${TODAY}.zip" "{YourDriveName}:JiHuangBackup/"
STATUS1=$?
sudo /usr/bin/rclone copy "/tmp/backup/DSTBackup_${TODAY}.tar" "{YourDriveName}:JiHuangBackup/"
STATUS2=$?
## 如果上传成功，发生成功；失败发送失败
if [ $STATUS1 -eq 0 -a $STATUS2 -eq 0 ]
then
   echo "成功"
   ## 备份成功推送服务（可选）
   ## https://push.example.com/
else
   echo "失败"
   ## 备份失败推送服务（可选）
   ## https://push.example.com/
fi
## 删除临时文件
rm -rf /tmp/backup/
########################
##### Backup Ends #####
########################
