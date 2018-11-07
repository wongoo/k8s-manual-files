#!/bin/sh

# see https://github.com/kubernetes/dashboard
curl -o addons/dashboard/kubernetes-dashboard.yaml https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

# check image version
grep "image: " addons/dashboard/kubernetes-dashboard.yaml 
sed -i -e "s#k8s.gcr.io/#registry.cn-hangzhou.aliyuncs.com/google_containers/#g" addons/dashboard/kubernetes-dashboard.yaml 

kubectl apply -f addons/dashboard/kubernetes-kashboard.yaml
kubectl apply -f addons/dashboard/kashboard-admin.yaml
# anonymous dashboard
# kubectl apply -f addons/dashboard/anonymous-proxy-rbac.yml
# kubectl delete -f addons/dashboard/anonymous-proxy-rbac.yml


# check service
kubectl -n kube-system get po,svc -l k8s-app=kubernetes-dashboard

# allow local access
#kubectl proxy --address='10.104.113.165' --accept-hosts='.*'
kubectl proxy --address='0.0.0.0' --accept-hosts='.*'

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
#http://10.104.113.160:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

# 在這邊會額外建立名稱為anonymous-dashboard-proxy的 Cluster Role(Binding) 
# 來讓system:anonymous這個匿名使用者能夠透過 API Server 來 proxy 到 Kubernetes Dashboard，
# 而這個 RBAC 規則僅能夠存取services/proxy資源，以及https:kubernetes-dashboard:資源名稱。
# 因此我們能夠在完成後，透過以下連結來進入 Kubernetes Dashboard：

# see: https://github.com/kubernetes/dashboard/wiki/Creating-sample-user
# 建立一個 Service Account 來綁定cluster-admin 以測試功能
kubectl -n kube-system create sa dashboard
kubectl create clusterrolebinding dashboard --clusterrole cluster-admin --serviceaccount=kube-system:dashboard
SECRET=$(kubectl -n kube-system get sa dashboard -o yaml | awk '/dashboard-token/ {print $3}')
kubectl -n kube-system describe secrets ${SECRET} | awk '/token:/{print $2}'
# 複製token然後貼到 Kubernetes dashboard


