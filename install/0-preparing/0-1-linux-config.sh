#!/bin/sh
#

for NODE in $K8S_ALL; do
    ssh $NODE systemctl stop firewalld && systemctl disable firewalld

    ssh $NODE setenforce 0

    ssh $NODE "cat <<EOF > /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF"

    ssh $NODE "sysctl -p /etc/sysctl.d/k8s.conf"

    ssh $NODE "swapoff -a && sysctl -w vm.swappiness=0"
    ssh $NODE "sed '/swap.img/d' -i /etc/fstab"

done