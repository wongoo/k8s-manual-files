#!/bin/sh

for NODE in $K8S_NODES; do
    echo "--- $NODE ---"

    ssh ${NODE} "mkdir -p /var/lib/kubelet /var/log/kubernetes /var/lib/etcd /var/lib/kube-proxy /etc/systemd/system/kubelet.service.d /etc/kubernetes/pki/ /etc/kubernetes/manifests"

    ssh ${NODE} "rm -rf /var/lib/kubelet/*"
    ssh ${NODE} "rm -rf /var/log/kubernetes/*"
    ssh ${NODE} "rm -rf /var/log/kube-proxy/*"
    ssh ${NODE} "rm -rf /var/log/pods/*"

    for FILE in pki/ca.pem pki/ca-key.pem pki/kube-proxy.pem pki/kube-proxy-key.pem kube-proxy.conf bootstrap-kubelet.conf; do
      scp /etc/kubernetes/${FILE} ${NODE}:/etc/kubernetes/${FILE}
    done

    scp node/var/lib/kubelet/config.yml ${NODE}:/var/lib/kubelet/config.yml
    scp node/systemd/kubelet.service ${NODE}:/lib/systemd/system/kubelet.service
    scp node/systemd/10-kubelet.conf ${NODE}:/etc/systemd/system/kubelet.service.d/10-kubelet.conf
done

