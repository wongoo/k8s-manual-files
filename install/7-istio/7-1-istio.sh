#!/bin/sh

# see https://istio.io/docs/setup/kubernetes/quick-start/
curl -L https://git.io/getLatestIstio | sh -

cd istio-*

export PATH=$PWD/bin:$PATH

# 安装 Istio 而不启用 sidecar 之间的双向 TLS 验证
kubectl apply -f install/kubernetes/istio-demo.yaml


# 默认情况下安装 Istio，并强制在 sidecar 之间进行双向 TLS 身份验证。
# kubectl apply -f install/kubernetes/istio-demo-auth.yaml<Paste>

# 确认下列 Kubernetes 服务已经部署：
# istio-pilot、 istio-ingressgateway、istio-policy、istio-telemetry、prometheus 、istio-sidecar-injector（可选）
kubectl get svc -n istio-system

# 确保所有相应的Kubernetes pod都已被部署且所有的容器都已启动并正在运行：
# istio-pilot-*、istio-ingressgateway-*、istio-egressgateway-*、istio-policy-*、istio-telemetry-*、istio-citadel-*、prometheus-*、istio-sidecar-injector-*（可选）。

kubectl get pods -n istio-system


# -----------------------
# 如果您启动了 Istio-Initializer，如上所示，您可以使用 kubectl create 直接部署应用。
# Istio-Initializer 会向应用程序的 Pod 中自动注入 Envoy 容器，如果运行 Pod 的 namespace 被标记为 istio-injection=enabled 的话：
# kubectl label namespace <namespace> istio-injection=enabled
# kubectl create -n <namespace> -f <your-app-spec>.yaml

# 如果您没有安装 Istio-initializer-injector 的话，您必须使用 istioctl kube-inject 命令在部署应用之前向应用程序的 Pod 中手动注入 Envoy 容器：
# kubectl create -f <(istioctl kube-inject -f <your-app-spec>.yaml)

# -----------------------
# 安装示例微服务: https://istio.io/docs/examples/bookinfo/
kubectl apply -f <(istioctl kube-inject -f samples/bookinfo/platform/kube/bookinfo.yaml)
kubectl get svc,pod -n default

kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl get gateway

# Confirm the app is running
kubectl get svc istio-ingressgateway -n istio-system

# Determining the ingress IP and ports when using an external load balancer
# export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
# export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
# export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

# Determining the ingress IP and ports when using a node port
export INGRESS_HOST=$(kubectl get po -l istio=ingressgateway -n istio-system -o 'jsonpath={.items[0].status.hostIP}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')

export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo $GATEWAY_URL
curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage

# Apply default destination rules
kubectl apply -f samples/bookinfo/networking/destination-rule-all.yaml
#  kubectl apply -f samples/bookinfo/networking/destination-rule-all-mtls.yaml
kubectl get destinationrules -o yaml

# delete 
samples/bookinfo/platform/kube/cleanup.sh
kubectl get virtualservices   #-- there should be no virtual services
kubectl get destinationrules  #-- there should be no destination rules
kubectl get gateway           #-- there should be no gateway
kubectl get pods              #-- the Bookinfo pods should be deleted


# -----------------------
# -----------------------
# uninstall
# kubectl delete -f install/kubernetes/istio.yaml
