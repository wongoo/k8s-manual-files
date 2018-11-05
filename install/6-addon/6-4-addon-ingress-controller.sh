#!/bin/sh


export INGRESS_VIP=172.22.132.8

sed -i "s/\${INGRESS_VIP}/${INGRESS_VIP}/g" addons/ingress-controller/ingress-controller-svc.yml

kubectl create ns ingress-nginx
kubectl apply -f addons/ingress-controller

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml

kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch

# check service
kubectl -n ingress-nginx get po,svc

#  check ingress controller
curl http://172.22.132.8:80 

# install nginx
kubectl apply -f apps/nginx/

kubectl get po,svc,ing


# ----> NORMAL test
curl 172.22.132.8 -H 'Host: nginx.k8s.local'

# ----> BAD test, will get 404
curl 172.22.132.8 -H 'Host: nginx1.k8s.local'


