#!/bin/sh

# check CSR status
kubectl get csr

#-------approve all CSR
kubectl get csr |grep csr | awk '{print $1}' | xargs kubectl certificate approve

# get po
kubectl -n kube-system get po

# By default, your cluster will not schedule pods on the master for security reasons. 
# If you want to be able to schedule pods on the master, run:
# This will remove the node-role.kubernetes.io/master taint from any nodes that have it, 
# including the master node, meaning that the scheduler will then be able to schedule pods everywhere.

# ---- 設定 Taints and Tolerations 來讓一些特定 Pod 能夠排程到所有master節點上
kubectl taint nodes node-role.kubernetes.io/master="":NoSchedule --all

# ---- 建立一個 RBAC Role 來獲取存取權限
kubectl apply -f master/resources/apiserver-to-kubelet-rbac.yml
# kubectl -n kube-system logs -f kube-apiserver-k8s-m1


