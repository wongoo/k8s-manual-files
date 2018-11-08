#!/bin/sh


sed -i "s/\${INGRESS_VIP}/${K8S_INGRESS_VIP}/g" addons/ingress-controller/ingress-controller-svc.yml

kubectl create ns ingress-nginx
kubectl apply -f addons/ingress-controller
# kubectl delete -f addons/ingress-controller

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
# kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch

# check service
kubectl -n ingress-nginx get po,svc

# kubectl -n ingress-nginx logs -f xxx

#  check ingress controller
curl http://${K8S_INGRESS_VIP}

# install nginx
kubectl apply -f apps/nginx/

kubectl get po,svc,ing


# ----> NORMAL test
curl ${K8S_INGRESS_VIP} -H 'Host: nginx.k8s.local'

# ----> BAD test, will get 404
curl ${K8S_INGRESS_VIP} -H 'Host: nginx1.k8s.local'


