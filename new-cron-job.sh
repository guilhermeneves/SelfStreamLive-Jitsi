#!/bin/bash

 # schedule cron-script to run ansible on reboot
 sudo crontab -l > newinit
 echo "@reboot . /etc/profile; /root/SelfStreamLive-Jitsi/cron-script.sh" >> newinit
 crontab newinit
 
 # schedule cron-script to run ansible on reboot
 sudo crontab -l > newinitb
 echo "0 */${contracted_hours} * * *  /root/SelfStreamLive-Jitsi/auto-destroy-scheduler.sh" >> newinitb
 crontab newinitb