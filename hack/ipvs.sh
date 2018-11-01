#!/bin/sh



#--------------允许转发
sysctl -a |grep net.ipv4.ip_forward
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf 
sysctl -p

#-------------安装ipvs管理工具
yum -y install ipvsadm ipset
touch /etc/sysconfig/ipvsadm 
# systemctl enable ipvsadm  &&  systemctl start ipvsadm 

#---------------ipvs
# 确保内核开启了ipvs模块
lsmod|grep ip_vs
# ip_vs_sh               12688  0
# ip_vs_wrr              12697  0
# ip_vs_rr               12600  16
# ip_vs                 141092  23 ip_vs_rr,ip_vs_sh,xt_ipvs,ip_vs_wrr
# nf_conntrack          133387  9 ip_vs,nf_nat,nf_nat_ipv4,nf_nat_ipv6,xt_conntrack,nf_nat_masquerade_ipv4,nf_conntrack_netlink,nf_conntrack_ipv4,nf_conntrack_ipv6
# libcrc32c              12644  3 ip_vs,nf_nat,nf_conntrack

# 没开启加载方式:
modprobe -- ip_vs
modprobe -- ip_vs_rr
modprobe -- ip_vs_wrr
modprobe -- ip_vs_sh
modprobe -- nf_conntrack_ipv4



