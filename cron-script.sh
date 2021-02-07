#!/bin/bash

export ipaddress=$(ip a s eth0 | awk '/inet / {print$2}' | head -1 | sed -r 's/.{3}$//')
cd /root/SelfStreamLive-Jitsi
ansible-playbook -i hosts site.yml -e "channelLastN=-1 defaultLanguage=en jicofo_user=focus jicofo_pass=selfstreamlive jicofo_secret=selfstreamlive run_exporter_container=false exporter_xmpp_user=prometheus exporter_xmpp_pass=selfstreamlive videobridge_user=meet videobridge_pass=selfstreamlive videobridge_muc_nick=meet jibri_user=jibri jibri_pass=selfstreamlive jibri_muc_nick=jibri myIpAddress=${ipaddress}" >> ansible.log
