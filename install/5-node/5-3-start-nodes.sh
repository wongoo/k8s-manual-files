#!/bin/sh

for NODE in $K8S_NODES; do
  echo "--- $NODE ---"
  ssh ${NODE} "systemctl enable kubelet.service && systemctl start kubelet.service"
done


