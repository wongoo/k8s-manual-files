#!/bin/sh
#

export CNI_URL=https://github.com/containernetworking/plugins/releases/download
CNI_PLUGIN_FILE=cni-plugins-amd64-${K8S_CNI_VERSION}.tgz
wget "${CNI_URL}/${K8S_CNI_VERSION}/${CNI_PLUGIN_FILE}"

# NOTE: /opt/cni/bin 为calico manifest 文件默认指定目录
for NODE in $K8S_ALL; do
    ssh $NODE "mkdir -p /opt/cni/bin"
    scp ${CNI_PLUGIN_FILE} $NODE:/opt/cni/bin/${CNI_PLUGIN_FILE}
    ssh $NODE "cd /opt/cni/bin ; tar -xvf cni*.tgz"
done
