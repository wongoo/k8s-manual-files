
# trouble shooting

# k8s commands

```
watch netstat -ntlp

kubectl get csr

kubectl get nodes

kubectl -n kube-system get po,svc

kubectl -n kube-system get cs

# ---- get wall pod list
kubectl get pod,svc --all-namespaces -o wide

#----- check log
kubectl -n kube-system logs -f kube-apiserver-k8s-m1
kubectl -n kube-system logs -f calico-node-xb4bf install-cni
kubectl -n kube-system logs -f calico-node-xb4bf calico-node

# ---- exec command in pod
kubectl -n kube-system exec coredns-568996f959-52szc -- curl -k -v https://10.96.0.1:443
kubectl -n kube-system exec calico-node-xb4bf -- ping 10.96.0.1


# ---- run calicoctl commands through the Pod using kubectl
kubectl exec -ti -n kube-system calicoctl -- /calicoctl get profiles -o wide
```

## check linux service log
```
watch netstat -ntlp
# 如果启动失败查看详细信息
# journalctl -xef
```

## Apiserver Forbidden 

eg, forbidden for query logs:
```bash
kubectl -n kube-system logs -f kube-apiserver-k8s-m1

Error from server (Forbidden): Forbidden (user=kube-apiserver, verb=get, resource=nodes, subresource=proxy) ( pods/log kube-apiserver-k8s-m1)
```
Add `ClusterRole` and `ClusterRoleBinding` to user to grant permission:
```
kubectl apply -f master/resources/apiserver-to-kubelet-rbac.yml
```

## add vip manually

```
ifconfig eth0:0 10.104.113.166 netmask 255.255.255.0 up
# ifconfig eth0:0 down
```
