#!/bin/sh
#

export CNI_VERSION=v0.7.1
export CNI_URL=https://github.com/containernetworking/plugins/releases/download
wget "${CNI_URL}/${CNI_VERSION}/cni-plugins-amd64-${CNI_VERSION}.tgz"

for NODE in $K8S_ALL; do
    ssh $NODE "mkdir -p /opt/cni/bin"
    scp cni-plugins-amd64-${CNI_VERSION}.tgz $NODE:/opt/cni/bin/cni-plugins-amd64-${CNI_VERSION}.tgz
    ssh $NODE "cd /opt/cni/bin ; tar -xvf cni*.tgz"
done
