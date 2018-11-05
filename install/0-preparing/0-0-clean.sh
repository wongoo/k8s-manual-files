#!/bin/sh
#
for NODE in $K8S_ALL; do
    ssh ${NODE} "systemctl stop kubelet.service && systemctl disable kubelet.service"
    ssh ${NODE} "docker ps -a -q | paste -sd ' ' | xargs docker rm --force"
    ssh ${NODE} "rm -rf /var/lib/etcd/*"
    ssh ${NODE} "rm -rf /var/lib/kubelet/*"
    ssh ${NODE} "rm -rf /var/lib/kube-proxy/*"
    ssh ${NODE} "rm -rf /var/log/kubernetes/*"
    ssh ${NODE} "rm -rf /var/log/pods/*"
    ssh ${NODE} "rm -rf /etc/kubenetes/*"
done


for NODE in $K8S_ALL; do
    ssh ${NODE} "systemctl stop kubelet.service"
    ssh ${NODE} "docker ps -a -q | paste -sd ' ' | xargs docker rm --force"
done

for NODE in $K8S_ALL; do
    ssh ${NODE} "systemctl start kubelet.service"
done
