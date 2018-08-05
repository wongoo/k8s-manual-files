#!/bin/sh
#

for NODE in $K8S_MASTERS; do
    echo "--- $NODE ---"
    ssh ${NODE} "mkdir -p /var/lib/kubelet /var/log/kubernetes /var/lib/etcd /etc/systemd/system/kubelet.service.d"
    scp master/var/lib/kubelet/config.yml ${NODE}:/var/lib/kubelet/config.yml
    scp master/systemd/kubelet.service ${NODE}:/lib/systemd/system/kubelet.service
    scp master/systemd/10-kubelet.conf ${NODE}:/etc/systemd/system/kubelet.service.d/10-kubelet.conf
done

for NODE in $K8S_MASTERS; do
    ssh ${NODE} "systemctl enable kubelet.service && systemctl start kubelet.service"
done
