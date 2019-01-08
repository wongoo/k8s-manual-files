#!/bin/sh
#
# Cluster IP CIDR: 10.244.0.0/16
# Service Cluster IP CIDR: 10.96.0.0/12
# DNS DN: cluster.local

# ---------------------------
#    Nodes And IPs
# ---------------------------
export K8S_M1_IP=10.104.113.161
export K8S_M2_IP=10.104.113.162
export K8S_M3_IP=10.104.113.163

export K8S_N1_IP=10.104.113.164
export K8S_N2_IP=10.104.113.165

export K8S_VIP=10.104.113.160
export K8S_INGRESS_VIP=10.104.113.166
export K8S_DNS_IP=10.96.0.10

export K8S_CLUSTER_IP=10.96.0.1

export K8S_MASTERS="k8s-m1 k8s-m2 k8s-m3"
export K8S_NODES="k8s-n1 k8s-n2"
export K8S_ALL="$K8S_MASTERS $K8S_NODES"
export K8S_APISERVER=https://$K8S_VIP:6443

# ---------------------------
#    Versions
# ---------------------------
# check versions of dependencies of k8s: 
#     https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.13.md#external-dependencies
#     https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.13.md#changelog-since-v1130
#
# update k8s version: sed -i -e "s/v1.13.1/v1.13.1/g" **/*.sh **/*.md **/*.yml **/*.conf
export K8S_VERSION=v1.13.1
export K8S_COREDNS_VERSION=v1.2.6

# sed -i "" -e "s/defaultbackend-amd64:1.4/defaultbackend-amd64:1.5/g" **/*.yml
export K8S_DEFAULTBACKEND_VERSION=1.5
export K8S_DASHBOARD_VERSION=v1.10.0
export K8S_PAUSEAMD_VERSION=3.1

# From release note at https://docs.projectcalico.org/v3.3/releases/, calico now support cni v0.7.1
export K8S_CNI_VERSION=v0.6.0
# NOTE this calico version is the minor version
export K8S_CALICO_VERSION=v3.3

# update file master/manifests/etcd.yml hack/docker-images-master.sh
export K8S_ETCD_VERSION=v3.2.24


# ---------------------------
#    Directories
# ---------------------------
export K8S_DIR=/etc/kubernetes
export PKI_DIR=${K8S_DIR}/pki

# ---------------------------
#    Show Config
# ---------------------------
env |grep K8S
