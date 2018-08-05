#!/bin/sh
#

export CNI_URL=https://github.com/containernetworking/plugins/releases/download
wget "${CNI_URL}/v0.7.1/cni-plugins-amd64-v0.7.1.tgz"

for NODE in $K8S_ALL; do
    ssh $NODE "mkdir -p /opt/cni/bin"
    scp cni-plugins-amd64-v0.7.1.tgz $NODE:/opt/cni/bin/cni-plugins-amd64-v0.7.1.tgz
    ssh $NODE "cd /opt/cni/bin ; tar -xvf cni*.tgz"
done
