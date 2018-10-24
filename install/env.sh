#!/bin/sh
#

export K8S_M1_IP=10.104.113.161
export K8S_M2_IP=10.104.113.162
export K8S_M3_IP=10.104.113.163

export K8S_N1_IP=10.104.113.164
export K8S_N2_IP=10.104.113.165

export K8S_VIP=10.104.113.166

export K8S_MASTERS="k8s-m1 k8s-m2 k8s-m3"
export K8S_NODES="k8s-n1 k8s-n2"
export K8S_ALL="$K8S_MASTERS $K8S_NODES"
export KUBE_APISERVER=https://$K8S_VIP:6443

export K8S_DIR=/etc/kubernetes
export PKI_DIR=${K8S_DIR}/pki

for NODE in $K8S_ALL; do
    echo $NODE
done

