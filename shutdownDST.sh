#!/bin/bash
#!/bin/bash
# Checking if Don't Starve Together Server is running
echo "Checking if Don't Starve Together Server is running"
echo "---------------------------------------------------"

listCurrentRunningScreen=$(screen -ls)

isContainName1=$(echo $listCurrentRunningScreen | grep "DST_CAVES")
if [[ $isContainName1 != "" ]];
then
    echo "Don't Starve Together Server(CAVES) is running, shutting down"
    screen -x DST_CAVES -p 0 -X stuff "c_shutdown()\n"
else
    echo "Don't Starve Together Server(CAVES) is not running"
fi

isContainName2=$(echo $listCurrentRunningScreen | grep "DST_MASTER")
if [[ $isContainName2 != "" ]];
then
    echo "Don't Starve Together Server(MASTER) is running, shutting down"
    screen -x DST_MASTER -p 0 -X stuff "c_shutdown()\n"
else
    echo "Don't Starve Together Server(MASTER) is not running"
fi
