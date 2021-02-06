#!/bin/bash

 sudo crontab -l > newinit
 #echo new cron into cron file

 echo "@reboot /root/SelfStreamLive-Jitsi/cron-script.sh" >> newinit #Schedule on reboot

#install new cron file
 crontab newinit
