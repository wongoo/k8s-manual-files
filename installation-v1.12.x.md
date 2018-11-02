
# Initial Installation Envirionment

client: 10.104.113.160

use `ssh-keygen` generate `id_rsa`, `id_rsa.pub`

config /etc/hosts on all hosts(centos):

```
10.104.113.161 k8s-m1
10.104.113.162 k8s-m2
10.104.113.163 k8s-m3
10.104.113.164 k8s-n1
10.104.113.165 k8s-n2
10.104.113.160 k8s-vip
```

vip: 10.104.113.166 k8s-master

add content of `id_rsa.pub` into file `/root/.ssh/authorized_keys` of all hosts.

k8s cluster ip range: 10.96.0.0


# TroubleShooting

## check service log
```
watch netstat -ntlp
# 如果启动失败查看详细信息
# journalctl -xef
```

## add vip manually

```
ifconfig eth0:0 10.104.113.166 netmask 255.255.255.0 up
# ifconfig eth0:0 down
```

