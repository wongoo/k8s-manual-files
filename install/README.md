
# 1. Prepration

config /etc/hosts on all hosts(centos):

```
10.104.113.161 k8s-m1
10.104.113.162 k8s-m2
10.104.113.163 k8s-m3
10.104.113.164 k8s-n1
10.104.113.165 k8s-n2
10.104.113.160 k8s-vip
```

on `k8s-vip` use `ssh-keygen` to generate `id_rsa`, `id_rsa.pub`,
add content of `id_rsa.pub` into file `/root/.ssh/authorized_keys` of all hosts.

And update `install/env.sh` 


# 2. Installation

First, initial env:
```
source install/env.sh
```

Then config linux and download installation binaries:
```
install/0-preparing/0-0-clean.sh
install/0-preparing/0-1-linux-config.sh
install/0-preparing/0-2-install-kubelet.sh
install/0-preparing/0-3-install-cni.sh
install/0-preparing/0-4-i0-preparing/nstall-cfssl.sh
```

## 2.1 generate config:
```
install/1-gen-cert/1-01-generate-etcd-ca.sh
install/1-gen-cert/1-02-generate-ca.sh
install/1-gen-cert/1-03-generate-front-proxy-ca.sh
install/1-gen-cert/1-04-generate-front-proxy-client.sh
install/1-gen-cert/1-05-cert-controller-manager.sh
install/1-gen-cert/1-06-cert-scheduler.sh
install/1-gen-cert/1-07-cert-admin.sh
install/1-gen-cert/1-08-cert-master-nodes.sh
install/1-gen-cert/1-09-cert-service-account.sh
install/1-gen-cert/1-10-kube-proxy.sh
install/1-gen-cert/1-11-cert-copy.sh
```

## 2.2 install master services:
```
install/2-masters/2-1-gen-configs.sh
install/2-masters/2-2-gen-manifests.sh
install/2-masters/2-4-kubelet-services.sh
install/2-masters/2-6-master-config.sh
```


## 2.3 bootstrap:
```
source install/3-bootstrap/3-0-bootstrap-var.sh

install/3-bootstrap/3-1-bootstrap-conf.sh
install/3-bootstrap/3-2-bootstrap-secret.sh
install/3-bootstrap/3-3-bootstrap-rbac.sh

```

## 2.5 node:
```
install/5-node/5-1-copy-node-config.sh
install/5-node/5-3-start-nodes.sh
install/5-node/5-4-nodes-config.sh
```

# 2.6 addon:
```
install/6-addon/6-1-addon-kube-proxy.sh
install/6-addon/6-2-addon-coredns.sh
install/6-addon/6-3-addon-network-calico.sh
install/6-addon/6-4-addon-ingress-controller.sh
install/6-addon/6-5-addon-external-dns.sh
install/6-addon/6-6-addon-dashboard.sh
install/6-addon/6-7-addon-prometheus.sh
```



