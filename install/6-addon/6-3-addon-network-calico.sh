#!/bin/sh

kubectl apply -f https://docs.projectcalico.org/${K8S_CALICO_VERSION}/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/${K8S_CALICO_VERSION}/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

#sed -i 's/192.168.0.0\/16/10.244.0.0\/16/g' cni/calico/v3.3/calico.yaml
#kubectl -f cni/calico/v3.3/

