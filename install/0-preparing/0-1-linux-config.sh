#!/bin/sh
#

# ------------------------
#  net.ipv4.ip_forward
#-------------------------
# 内网主机向公网发送数据包时，由于目的主机跟源主机不在同一网段，所以数据包暂时发往内网默认网关处理，而本网段的主机对此数据包不做任何回应。由于源主机ip是私有的，禁止在公网使用，所以必须将数据包的源发送地址修改成公网上的可用ip，这就是网关收到数据包之后首先要做的工作--ip转换。然后网关再把数据包发往目的主机。目的主机收到数据包之后，只认为这是网关发送的请求，并不知道内网主机的存在，也没必要知道，目的主机处理完请求，把回应信息发还给网关。网关收到后，将目的主机发还的数据包的目的ip地址修改为发出请求的内网主机的ip地址，并将其发给内网主机。这就是网关的第二个工作--数据包的路由转发。内网的主机只要查看数据包的目的ip与发送请求的源主机ip地址相同，就会回应，这就完成了一次请求。
# 出于安全考虑，Linux系统默认是禁止数据包转发的。所谓转发即当主机拥有多于一块的网卡时，其中一块收到数据包，根据数据包的目的ip地址将包发往本机另一网卡，该网卡根据路由表继续发送数据包。这通常就是路由器所要实现的功能。

# --------------------------
# net.bridge.bridge-nf-call-*
# --------------------------
# These control whether or not packets traversing the bridge are sent to iptables for processing. In the case of using bridges to connect virtual machines to the network, generally such processing is *not* desired, as it results in guest traffic being blocked due to host iptables rules that only account for the host itself, and not for the guests.
# see: https://wiki.libvirt.org/page/Net.bridge.bridge-nf-call_and_sysctl.conf

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
