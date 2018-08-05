#!/bin/sh
#

export K8S_MASTERS="k8s-m1 k8s-m2 k8s-m3"
export K8S_NODES="k8s-n1 k8s-n2 k8s-n3"
export K8S_ALL="$K8S_MASTERS $K8S_NODES"
export KUBE_APISERVER=https://10.204.0.4:6443

export K8S_DIR=/etc/kubernetes
export PKI_DIR=${K8S_DIR}/pki

for NODE in $K8S_ALL; do
    echo $NODE
done

