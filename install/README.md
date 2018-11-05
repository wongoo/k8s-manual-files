# env

```
source install/env.sh
```

# prepare:
```
install/0-preparing/0-0-clean.sh
install/0-preparing/0-1-linux-config.sh
install/0-preparing/0-2-install-kubelet.sh
install/0-preparing/0-3-install-cni.sh
install/0-preparing/0-4-i0-preparing/nstall-cfssl.sh

```

# generate config:
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

# install master services:
```
install/2-masters/2-1-gen-configs.sh
install/2-masters/2-2-gen-manifests.sh
install/2-masters/2-4-kubelet-services.sh
install/2-masters/2-6-master-config.sh
```


# bootstrap:
```
source install/3-bootstrap/3-0-bootstrap-var.sh

install/3-bootstrap/3-1-bootstrap-conf.sh
install/3-bootstrap/3-2-bootstrap-secret.sh
install/3-bootstrap/3-3-bootstrap-rbac.sh

```

# 5-node:
```
install/5-node/5-1-copy-node-config.sh
install/5-node/5-3-start-nodes.sh
install/5-node/5-4-nodes-config.sh
```

# 6-addon:
```
install/6-addon/6-1-addon-kube-proxy.sh
install/6-addon/6-2-addon-coredns.sh
install/6-addon/6-3-addon-network-calico.sh

```



