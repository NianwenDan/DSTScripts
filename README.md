# 饥荒联机版自动备份&更新代码
本脚本可以帮您自动更新、自动备份饥荒联机版，已在Ubuntu 20.04 LTS测试可正常使用。

## 检查运行环境

1. 检查`Screen`窗口管理器是否正确安装。

```shell
screen -v
```

如果出现报错，根据不同系统通过下列代码安装

Debian/Ubuntu 系统：`apt-get install screen`

CentOS系统：`yum install screen`

2. 如果您使用自动备份脚本，请确保用户有**免密码`sudo`权限**，下载并安装[rclone](https://rclone.org/downloads/)管理器，并修改`DST_backup.sh`文件第23，25行`{YourDriveName}`部分为你的rclone云盘名称。详细信息请参考[rclone官方文档](https://rclone.org/commands/rclone_copy/)。
3. 请确保`zip`命令可以正常使用。
4. 推荐与[Steam平台饥荒联机版管理后台](https://github.com/qinming99/dst-admin)一同使用。
5. 如果有**推送服务**的需求，请修改`DST_backup.sh`第29-37行，`DST_applyUpdate.sh`第18-19行。

## 开始使用

1. 在主目录新建一个名为`script`的文件夹**（请勿修改文件夹名）**

```shell
mkdir ~/script
```

2. 将脚本拷贝至`script`的文件夹内

目录结构：

```
script/
├── autoUpdate
│   ├── currentVersion.txt
│   ├── DST_applyUpdate.sh
│   ├── DST_checkUpToDate.sh
│   └── DST_getCurrentVersion.sh
├── DST_backup.sh
└── shutdownDST.sh
```

3. 给予运行、写入权限

```shell
chmod -R +x ~/script
chmod -R 755 ~/script
```

4. 手动测试脚本是否可以正常运行

```shell
cd ~/script

# 运行备份脚本
./DST_backup.sh

# 运行更新脚本
./autoUpdate/DST_checkUpToDate.sh
```

如果运行出现报错，请参考**脚本原理**排除报错。

5. 设置crontab定时运行脚本

```shell
crontab -e
```
添加如下内容：


```shell
# 饥荒自动备份脚本（每天早上9点运行一次）
0 9 * * * /bin/bash ~/script/DST_backup.sh
# 饥荒自动更新脚本（每隔15分钟运行一次）
*/15 * * * * /bin/bash ~/script/autoUpdate/DST_checkUpToDate.sh
```

## 脚本原理

`DST_backup.sh`: 

饥荒联机版自动备份脚本，正式备份前会调用`shutdownDST.sh`脚本检查饥荒联机版是否正在运行。若检测到正在运行，则关闭服务并等待30秒开始备份；若未检测到正在运行，则立即开始备份。



`shutdownDST.sh`:

通过`Screen`命令检测是否存在存在名为`DST_CAVES`和`DST_MASTER`的窗口。若存在，则判定饥荒服务正在运行，并向窗口内发送`c_shutdown()`指令关闭服务，若不存在，则判定饥荒服务未运行。



`currentVersion.txt`:

文件记录了当前饥荒服务器的版本号。



`DST_getCurrentVersion.sh`:

脚本会通过`steamcmd.sh`获取最新饥荒服务器的版本号。



`DST_checkUpToDate.sh`:

脚本会比对最新饥荒服务器的版本号和当前饥荒服务器的版本号（`currentVersion.txt`），若版本号不一样，则判定为有更新，并调用`DST_applyUpdate.sh`脚本。



`DST_applyUpdate.sh`:

脚本会首先检测是否存在名为`DST_MASTER`的Screen窗口，若存在则判定为饥荒服务器正在运行，并放弃本次更新（防止在游戏途中自动更新）；若游戏服务未运行，则立即开始更新并将最新版本号存入`currentVersion.txt`文件内。
