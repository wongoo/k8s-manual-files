#!/bin/sh

# kube-proxy 是實現 Kubernetes Service 資源功能的關鍵元件
# 這個元件會透過 DaemonSet 在每台節點上執行，然後監聽 API Server 的 Service 與 Endpoint 資源物件的事件
# 並依據資源預期狀態透過 iptables 或 ipvs 來實現網路轉發，而本次安裝採用 ipvs。
# ipvs介绍: https://www.server-world.info/en/note?os=CentOS_7&p=lvs

# 参考: 
# https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/kube-proxy/kube-proxy-ds.yaml
# https://github.com/kubernetes/kubernetes/blob/master/cluster/addons/kube-proxy/kube-proxy-rbac.yaml
# command line args: https://kubernetes.io/docs/reference/command-line-tools-reference/kube-proxy/

sh -c "sed -i 's#\${KUBE_APISERVER}#${KUBE_APISERVER}#g' addons/kube-proxy/kube-proxy-cm.yml"

# see https://kubernetes.io/docs/reference/federation/extensions/v1beta1/definitions/#_v1beta1_daemonset

# kube-proxy configuration 
# https://github.com/kubernetes/kubernetes/blob/master/staging/src/k8s.io/kube-proxy/config/v1alpha1/types.go
kubectl apply -f addons/kube-proxy/kube-proxy-cm.yml
kubectl apply -f addons/kube-proxy/kube-proxy-rbac.yml
kubectl apply -f addons/kube-proxy/kube-proxy-ds.yml

kubectl describe clusterrolebinding system:node-proxier

# -----------------
# kubectl delete -f addons/kube-proxy/

kubectl -n kube-system get po -l k8s-app=kube-proxy

# ---> 檢查 log 是否使用 ipvs
# kubectl -n kube-system logs -f kube-proxy-fwgx8


