
# trouble shooting commands

```
watch netstat -ntlp

kubectl get csr

kubectl get nodes

kubectl -n kube-system get po,svc

kubectl -n kube-system get cs

# ---- get wall pod list
kubectl get pod --all-namespaces --show-all -o wide

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


