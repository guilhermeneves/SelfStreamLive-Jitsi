#!/bin/bash

export ipaddress=$(ip a s eth0 | awk '/inet / {print$2}' | head -1 | sed -r 's/.{3}$//')
export eventName=$(hostname)
export secret="${eventId}${eventName}"

cd /root/SelfStreamLive-Jitsi
mv /root/SelfStreamLive-Jitsi/host_vars/meuevento-hosts "/root/SelfStreamLive-Jitsi/host_vars/${eventName}"

sed -i '/meet_domain: meuevento-hosts.selfstream.live/c\meet_domain: '"${eventName}"'.selfstream.live' /root/SelfStreamLive-Jitsi/group_vars/meet/main.yml
sed -i '/vault_token_auth_appsecret: selfstreamlive/c\vault_token_auth_appsecret: '"${secret}"'' /root/SelfStreamLive-Jitsi/group_vars/meet/0secret.yml
sed -i '/vault_turn_secret: selfstreamlive/c\vault_turn_secret: '"${secret}"'' /root/SelfStreamLive-Jitsi/group_vars/meet/0secret.yml

sed -i 's/\<meuevento-hosts\>/'"${eventName}"'/g' /root/SelfStreamLive-Jitsi/hosts
sed -i '/jvb.selfstream.live/c\'"${eventName}"'-jvb.selfstream.live' /root/SelfStreamLive-Jitsi/hosts
sed -i '/jibri.selfstream.live/c\'"${eventName}"'-jibri.selfstream.live' /root/SelfStreamLive-Jitsi/hosts


ansible-playbook -i hosts site.yml -e "channelLastN=-1 defaultLanguage=en jicofo_user=focus jicofo_pass=${secret} jicofo_secret=${secret} run_exporter_container=false exporter_xmpp_user=prometheus exporter_xmpp_pass=${secret} videobridge_user=meet videobridge_pass=${secret} videobridge_muc_nick=meet jibri_user=jibri jibri_pass=${secret} jibri_muc_nick=jibri myIpAddress=${ipaddress}" >> ansible.log
