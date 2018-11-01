#!/bin/sh

watch netstat -ntlp

kubectl get csr

kubectl get nodes

kubectl -n kube-system get po

kubectl -n kube-system get cs

kubectl -n kube-system logs -f kube-apiserver-k8s-m1


