#!/bin/sh

systemctl enable ntpd
systemctl start ntpd
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

#=========for client
vi /etc/ntp.conf
server 10.104.113.160 prefer

