#!/bin/sh

export DNS_VIP=172.22.132.8

sed -i "s/\${DNS_VIP}/${DNS_VIP}/g" addons/external-dns/coredns/coredns-svc-tcp.yml
sed -i "s/\${DNS_VIP}/${DNS_VIP}/g" addons/external-dns/coredns/coredns-svc-udp.yml

kubectl create ns external-dns
kubectl create -f addons/external-dns/coredns/
kubectl -n external-dns get po,svc

# 透過 dig 工具來檢查是否 DNS 是否正常
# -----> instatll dig command: yum -y install bind-utils
dig @172.22.132.8 SOA nginx.k8s.local +noall +answer +time=2 +tries=1

# 部署 ExternalDNS 來與 CoreDNS 同步資源紀錄：
kubectl apply -f addons/external-dns/external-dns/
kubectl -n external-dns get po -l k8s-app=external-dns

# check
dig @172.22.132.8 A nginx.k8s.local +noall +answer +time=2 +tries=1
nslookup nginx.k8s.local
curl nginx.k8s.local
