#!/bin/bash
#
# Setup vagrant vms.
#

set -eu

# Copy hosts info
cat <<EOF > /etc/hosts
127.0.0.1	localhost
127.0.1.1	vagrant.vm	vagrant

10.104.113.161 k8s-m1
10.104.113.162 k8s-m2
10.104.113.163 k8s-m3
10.104.113.164 k8s-n1
10.104.113.165 k8s-n2

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

# Install docker
curl -fsSL "https://get.docker.com/" | sh
systemctl enable docker

# Download kubelet and kubectl
KUBE_URL="https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64"
wget "${KUBE_URL}/kubelet" -O /usr/local/bin/kubelet
chmod +x /usr/local/bin/kubelet

if [[ ${HOSTNAME} =~ m ]]; then
  wget "${KUBE_URL}/kubectl" -O /usr/local/bin/kubectl
  chmod +x /usr/local/bin/kubectl
fi

# Download CNI bin
mkdir -p /opt/cni/bin && cd /opt/cni/bin
CNI_URL="https://github.com/containernetworking/plugins/releases/download"
wget -qO- --show-progress "${CNI_URL}/v0.7.1/cni-plugins-amd64-v0.7.1.tgz" | tar -zx

# Setup system vars
cat <<EOF > /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl -p /etc/sysctl.d/k8s.conf
swapoff -a && sysctl -w vm.swappiness=0
sed '/vagrant--vg-swap_1/d' -i  /etc/fstab
