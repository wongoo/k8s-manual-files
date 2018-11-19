#!/bin/sh

# kubectl delete -f addons/external-dns/external-dns/
# kubectl delete -f addons/external-dns/coredns/

sed -i "s/\${DNS_VIP}/${K8S_INGRESS_VIP}/g" addons/external-dns/coredns/coredns-svc-tcp.yml
sed -i "s/\${DNS_VIP}/${K8S_INGRESS_VIP}/g" addons/external-dns/coredns/coredns-svc-udp.yml

kubectl create ns external-dns
kubectl apply -f addons/external-dns/coredns/
kubectl -n external-dns get po,svc

# 透過 dig 工具來檢查是否 DNS 是否正常
# -----> instatll dig command: yum -y install bind-utils
# 域名為k8s.local，可以修改檔案中的coredns-cm.yml
dig @${K8S_INGRESS_VIP} SOA nginx.k8s.local +noall +answer +time=2 +tries=1

# 部署 ExternalDNS 來與 CoreDNS 同步資源紀錄：
kubectl apply -f addons/external-dns/external-dns/
kubectl -n external-dns get po -l k8s-app=external-dns

# ===> 修改 /etc/resolv.conf 添加 nameserver 10.104.113.166 
	
# check
dig @${K8S_INGRESS_VIP} A nginx.k8s.local +noall +answer +time=2 +tries=1
nslookup nginx.k8s.local
curl nginx.k8s.local

# -------------- delete
# kubectl delete -f addons/external-dns/external-dns/
# kubectl delete -f addons/external-dns/coredns/


