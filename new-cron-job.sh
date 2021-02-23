#!/bin/bash

 sudo crontab -l > newinit
 # schedule cron-script to run ansible on reboot
 echo "@reboot . /etc/profile; /root/SelfStreamLive-Jitsi/cron-script.sh" >> newinit
 # schedule cron-script to auto-destroy droplet
 current_minute=$(date +"%M")
 echo "${current_minute} */${contracted_hours} * * *  /root/SelfStreamLive-Jitsi/auto-destroy-scheduler.sh" >> newinit
 crontab newinit