# Jitsi Meet Ansible Playbook

This playbook will install the Jitsi Meet stack in one or more servers.  It is
developed and tested on Debian 10 Buster. It may work on other Debian releases
or Ubuntu, but it has not been tested there.

Before using it you may want to read a bit about Jitsi Meet's arquitecture [here](https://docs.easyjitsi.com/docs/architecture) or [here](https://github.com/jitsi/jitsi-meet/blob/master/doc/scalable-installation.md) or [aquí (in Spanish)](https://blog.inittab.org/administracion-sistemas/instalar-un-servidor-de-videoconferencia-libre-jitsi-meet-i-la-teoria/)

# TODO

- [X] Fix Ansible Variables not working.
- [X] Check snd_aloop module not found. (https://github.com/emrahcom/emrah-buster-templates/blob/master/doc/jitsi_cluster.md??) or (https://community.jitsi.org/t/best-easy-method-to-scale-jibri-2-4-recorders/64797/4)
- [ ] Receive ID Customer as Env-Var and create a Jitsi with this password as token.
- [ ] Remove the screen to create meeting and when exit does not go there.
- [ ] Receive Subdomain as Env-Var and change strings and sub-folder name in host_vars/event-name
- [X] Create an env-var with ip-address and change ansible-playbook command
- [ ] Create a Custom Jitsi Server with a SelfStream Subdomain passing as parameter.
- [ ] Pass token, RTMP url, Event-ID as Env Vars and Configure Jitsi to use it.
- [ ] Jitsi Layout Custom option to show 2 people when more in a meeting (https://github.com/cketti/jitsi-hacks)
- [ ] Jitsi Layout Custom option to add name as a label in the bottom (https://github.com/cketti/jitsi-hacks)
- [ ] Jitsi Layout Custom option to add a imagem in the video (https://github.com/cketti/jitsi-hacks)
- [ ] Remove: Meeting in compact format and Invite People button from menu 
- [ ] API to Monitoring Jitsi Meeting Usage.
- [ ] Configure Droplet Alerts to CPU and Inbound and Outbound Net https://www.digitalocean.com/docs/monitoring/quickstart/


videobridge Error:
TASK [videobridge : Install Videobridge] ***************************************
fatal: [jvb.selfstream.live]: FAILED! => {"cache_update_time": 1612398261, "cache_updated": false, "changed": false, "msg": "'/usr/bin/apt-get -y -o \"Dpkg::Options::=--force-confdef\" -o \"Dpkg::Options::=--force-confold\"      install 'jitsi-videobridge2'' failed: E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)\nE: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?\n", "rc": 100, "stderr": "E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)\nE: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?\n", "stderr_lines": ["E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)", "E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?"], "stdout": "", "stdout_lines": []}


Jibri Error
TASK [jibri : Load snd-aloop or fail because of an invalid kernel] *************
fatal: [jibri.selfstream.live]: FAILED! => {"changed": false, "cmd": ["modprobe", "snd-aloop"], "delta": "0:00:00.018568", "end": "2021-02-04 00:28:40.881485", "msg": "non-zero return code", "rc": 1, "start": "2021-02-04 00:28:40.862917", "stderr": "modprobe: FATAL: Module snd-aloop not found in directory /lib/modules/4.19.0-10-cloud-amd64", "stderr_lines": ["modprobe: FATAL: Module snd-aloop not found in directory /lib/modules/4.19.0-10-cloud-amd64"], "stdout": "", "stdout_lines": []}



## How do I use it?

Simple clone it and rename the host configuration directories in *hosts_vars/*
to match your hosts.
Also edit *group_vars/meet* and the *hosts* file to suit your needs.
Further instructions in [USAGE.md](USAGE.md).
If you're using a git repository to hold your configuration, don't forget to
use **ansible-vault** to encrypt sensitive information. That's why the passwords
are stored on *0secret.yml* files.

You may run everything on one host. Or have separate hosts for videobridges and
jibris. If you want to run a videobridge and/or a jibri instance on the central
server, just include it in the "[videobridges]" and/or "[jibris]" group.

The *meet_domain* variable in *group_vars/meet* should have a DNS entry and
point to your "central" server since a Let's Encrypt certificate will be
generated during the installation.

Once you've gone through the hosts/variables you may run the playbook with:
```
    ansible-playbook -i hosts site.yml -e "channelLastN=-1 defaultLanguage=en jicofo_user=focus jicofo_pass=selfstreamlive jicofo_secret=selfstreamlive run_exporter_container=false exporter_xmpp_user=prometheus exporter_xmpp_pass=selfstreamlive videobridge_user=meet videobridge_pass=selfstreamlive videobridge_muc_nick=meet jibri_user=jibri jibri_pass=selfstreamlive jibri_muc_nick=jibri myIpAddress=68.183.139.133"
```
If your hosts are behind NAT or a firewall, remember to check the ports
required to run Jitsi Meet (80,443 TCP and 1000 UDP at least).

## User authentication support

This playbook supports three kinds of user authentication, all managed in
*group_vars/meet/main.yml*:
- None, everyone can join or start a room
- Token based, so your application can issue tokens that control user access
  and permissions (moderators). For example using [Moodle's token module](https://github.com/udima-university/moodle-mod_jitsi)
- LDAP based. Well... that.

Both token and LDAP authentication can also allow non-authenticated users in
(depending on the *allow_guests* value).

You may switch from one authentication scheme to another by editing the file
previously mentioned and running:

    ansible-playbook -i hosts site.yml --tags authconf

## What are the system requirements for running ~~Jitsi Meet~~ a jibri instance?

Jibri depends on the [ALSA loopback module](https://github.com/jitsi/jibri/blob/master/README.md#alsa-and-loopback-device).
If your server is running on a cloud platform, or with a kernel other than
Debian's default, make sure you have support for the "snd-aloop" module
**before** running the playbook on it.

For example, on Google Cloud instances, you need to run:

    apt install linux-image-amd64
    apt purge linux-image-*cloud*
    reboot

After that, you may run the playbook.

## Final notes

The playbook has some hacks, like using Debian's certbot package instead of
downloading it from Jitsi's packages postint or installing openjdk-8 from
Stretch, to better deal with some packaging behaviour/configuration in
ansible. The Jitsi project is **very** active nowadays and this playbook will
be (hopefully) frequently revisited to adapt to its changes. Please report any
issues or send your PRs.

## Droplets Sizes API

https://slugs.do-api.dev/

## Commands to User-Data Droplet

Updating Droplet

```
$ apt-get update
$ apt-get -y install sudo
$ sudo apt-get -y upgrade
$ sudo apt-get -y install gnupg
$ sudo apt-get -y install git

```

Cloning Private SelfStream Jitsi Repo

```
$ cd ..
$ git clone https://eb60ea0493dbc8963018d274eb6ef3856f69e774@github.com/guilhermeneves/SelfStreamLive-Jitsi.git

```

Installing Ansible

```
$ sed -i '$d' /etc/apt/sources.list
$ echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
$ sudo apt-get update
$ sudo apt-get -y install ansible

```

User-data Param to create a Droplet

```
   "user_data": " #cloud-config\nruncmd:\n - apt-get update\n - apt-get -y install sudo\n - sudo apt-get -y upgrade\n - sudo apt-get -y install git\n - sudo apt-get -y install gnupg\n - cd /root\n - git clone https://eb60ea0493dbc8963018d274eb6ef3856f69e774@github.com/guilhermeneves/SelfStreamLive-Jitsi.git\n - sed -i '$d' /etc/apt/sources.list\n - echo \"deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main\" >> /etc/apt/sources.list\n - sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367\n - sudo apt-get update\n - sudo apt-get -y install ansible\n - sudo apt-get -y install curl\n - export ipaddress=$(ip a s eth0 | awk '/inet / {print$2}' | head -1 | sed -r 's/.{3}$//')\n - 'curl --request POST --url https://api.digitalocean.com/v2/domains/selfstream.live/records --header \"Authorization: Bearer 896ba0377c79ab6276fda8ffc423a66ded35480ab94be700fe2f53f05fb92db5\" --cookie __cfduid=dd32467e27572b22a4c897e4c2e94906a1611618721 --data ''{\"type\": \"A\",\"name\": \"meuevento-hosts\",\"data\": \"''\"${ipaddress}\"''\",\"priority\": null,\"port\": null,\"ttl\": 30, \"weight\": null, \"flags\": null,\"tag\": null}'''\n - sleep 30s\n - cd SelfStreamLive-Jitsi\n - ansible-playbook -i hosts site.yml -e \"channelLastN=-1 defaultLanguage=en jicofo_user=focus jicofo_pass=selfstreamlive jicofo_secret=selfstreamlive run_exporter_container=false exporter_xmpp_user=prometheus exporter_xmpp_pass=selfstreamlive videobridge_user=meet videobridge_pass=selfstreamlive videobridge_muc_nick=meet jibri_user=jibri jibri_pass=selfstreamlive jibri_muc_nick=jibri myIpAddress=${ipaddress}\" "

```

Checking Logs for User-Data

```
cat /var/log/cloud-init-output.log

```

Validate Cloud-Init Template

```

cloud-init devel schema --config-file test.yaml

```

YAML Template Example

```

#cloud-config
runcmd:
- 'curl --request POST --url https://api.digitalocean.com/v2/domains/selfstream.live/records --header "Authorization: Bearer 896ba0377c79ab6276fda8ffc423a66ded35480ab94be700fe2f53f05fb92db5" --cookie __cfduid=dd32467e27572b22a4c897e4c2e94906a1611618721 --data "{\"type\": \"A\","name": "meuevento-hosts","data": "10.0.0.0","priority": null,"port": null,"ttl": 30, "weight": null, "flags": null,"tag": null}"'


```

