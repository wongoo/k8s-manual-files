#!/bin/sh

for NODE in $K8S_NODES; do
  echo "--- $NODE ---"
  ssh ${NODE} "systemctl enable kubelet.service && systemctl start kubelet.service"
done

for NODE in $K8S_ALL; do
  echo "--- $NODE ---"
  ssh ${NODE} "systemctl stop kubelet.service"
done

kubectl get csr

kubectl get nodes

