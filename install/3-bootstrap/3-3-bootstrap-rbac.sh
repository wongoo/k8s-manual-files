#!/bin/sh
#

# 建立 TLS Bootstrap Autoapprove RBAC 來提供自動受理 CSR：

kubectl apply -f master/resources/kubelet-bootstrap-rbac.yml
