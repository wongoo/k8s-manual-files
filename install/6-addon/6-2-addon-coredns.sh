#!/bin/sh

#  参考: https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns/coredns

#  Kubernetes 提供了 DNS 服務來作為查詢，讓 Pod 能夠以 Service 名稱作為域名來查詢 IP 位址，
#  因此使用者就再不需要關切實際 Pod IP，而 DNS 也會根據 Pod 變化更新資源紀錄(Record resources)

kubectl create -f addons/coredns/

kubectl -n kube-system get po -l k8s-app=kube-dns

