#!/bin/sh
#

for NODE in $K8S_MASTERS; do
    ssh ${NODE} "systemctl stop kubelet.service"
    ssh ${NODE} "docker ps |grep -v haproxy | grep -v CONTAINER| awk '{print $1}' |paste -sd ' ' | xargs docker rm --force"
done

# ---------------clean if exists previous installation
for NODE in $K8S_MASTERS; do
    ssh ${NODE} "rm -f /etc/kubernetes/manifests/haproxy.yml /etc/kubernetes/manifests/keepalived.yml"
    ssh ${NODE} "rm -rf /var/lib/etcd/*"
    ssh ${NODE} "rm -rf /var/lib/kubelet/*"
    ssh ${NODE} "rm -rf /var/lib/kube-proxy/*"
    ssh ${NODE} "rm -rf /var/log/kubernetes/*"
    ssh ${NODE} "rm -rf /var/log/pods/*"

    scp master/var/lib/kubelet/config.yml ${NODE}:/var/lib/kubelet/config.yml
done

for NODE in $K8S_MASTERS; do
    ssh ${NODE} "systemctl start kubelet.service"
done


