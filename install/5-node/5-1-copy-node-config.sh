#!/bin/sh

for NODE in $K8S_NODES; do
    echo "--- $NODE ---"
    ssh ${NODE} "mkdir -p /etc/kubernetes/pki/"
    for FILE in pki/ca.pem pki/ca-key.pem bootstrap-kubelet.conf; do
      scp /etc/kubernetes/${FILE} ${NODE}:/etc/kubernetes/${FILE}
    done

    ssh ${NODE} "mkdir -p /var/lib/kubelet /var/log/kubernetes /var/lib/etcd /etc/systemd/system/kubelet.service.d /etc/kubernetes/manifests"
    scp node/var/lib/kubelet/config.yml ${NODE}:/var/lib/kubelet/config.yml
    scp node/systemd/kubelet.service ${NODE}:/lib/systemd/system/kubelet.service
    scp node/systemd/10-kubelet.conf ${NODE}:/etc/systemd/system/kubelet.service.d/10-kubelet.conf
done

