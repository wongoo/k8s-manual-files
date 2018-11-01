#!/bin/sh

# ---- 建立一個 RBAC Role 來獲取存取權限
kubectl apply -f master/resources/apiserver-to-kubelet-rbac.yml
# kubectl -n kube-system logs -f kube-apiserver-k8s-m1

# ---- 設定 Taints and Tolerations 來讓一些特定 Pod 能夠排程到所有master節點上
kubectl taint nodes node-role.kubernetes.io/master="":NoSchedule --all

#-------approve all CSR
kubectl get csr |grep csr | awk '{print $1}' | xargs kubectl certificate approve

# check CSR status
kubectl get csr

# get po
kubectl -n kube-system get po
