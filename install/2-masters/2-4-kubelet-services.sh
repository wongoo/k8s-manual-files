#!/bin/sh
#

for NODE in $K8S_MASTERS; do
    echo "--- $NODE ---"
    ssh ${NODE} "mkdir -p /var/lib/kubelet /var/log/kubernetes /var/lib/etcd /var/lib/kube-proxy/ /etc/systemd/system/kubelet.service.d"

    ssh ${NODE} "rm -rf /var/lib/etcd/*"
    ssh ${NODE} "rm -rf /var/lib/kubelet/*"
    ssh ${NODE} "rm -rf /var/lib/kube-proxy/*"
    ssh ${NODE} "rm -rf /var/log/kubernetes/*"
    ssh ${NODE} "rm -rf /var/log/pods/*"

    scp master/var/lib/kubelet/config.yml ${NODE}:/var/lib/kubelet/config.yml
    scp master/systemd/kubelet.service ${NODE}:/lib/systemd/system/kubelet.service
    scp master/systemd/10-kubelet.conf ${NODE}:/etc/systemd/system/kubelet.service.d/10-kubelet.conf

    ssh ${NODE} "systemctl enable docker && systemctl start docker"
    ssh ${NODE} "systemctl enable kubelet.service && systemctl start kubelet.service"
done


