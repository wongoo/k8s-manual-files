#!/bin/sh
#

export KUBE_URL=https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64
wget ${KUBE_URL}/kubelet -O /usr/local/bin/kubelet
wget ${KUBE_URL}/kubectl -O /usr/local/bin/kubectl
chmod +x /usr/local/bin/kube*

for NODE in $K8S_ALL; do
    scp /usr/local/bin/kubelet $NODE:/usr/local/bin/kubelet
    scp /usr/local/bin/kubectl $NODE:/usr/local/bin/kubectl

    ssh $NODE "chmod +x /usr/local/bin/kube*"
done
