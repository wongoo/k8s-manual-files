#!/bin/sh

# ----- SEE: 
# https://github.com/coredns/coredns
# https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/dns/coredns
# https://github.com/coredns/deployment/tree/master/kubernetes

#  Kubernetes 提供了 DNS 服務來作為查詢，讓 Pod 能夠以 Service 名稱作為域名來查詢 IP 位址，
#  因此使用者就再不需要關切實際 Pod IP，而 DNS 也會根據 Pod 變化更新資源紀錄(Record resources)
# custom DNS: https://github.com/coredns/coredns.io/blob/master/content/blog/custom-dns-and-kubernetes.md

CURR_DIR=$(pwd)
COREDNS_DIR=${CURR_DIR}/addons/coredns/${K8S_COREDNS_VERSION} 
mkdir -p $COREDNS_DIR

if [ -f ${COREDNS_DIR}/coredns.yaml ]; then
	echo "coredns.yaml exists"
else
	mkdir -p temp
	rm -rf temp/coredns-deployment
	git clone --depth=1 https://github.com/coredns/deployment.git temp/coredns-deployment
	cd temp/coredns-deployment/kubernetes
	./deploy.sh -s -i ${K8S_DNS_IP}> ${COREDNS_DIR}/coredns.yaml
	cd ${CURR_DIR}
fi

kubectl create -f ${COREDNS_DIR}

sleep 10

kubectl -n kube-system get po -l k8s-app=kube-dns


nslookup nginx.default.svc.cluster.local
# Server:	10.96.0.10
# Address:	10.96.0.10#53
# 
# Name:	nginx.default.svc.cluster.local
# Address: 10.96.255.121
