
# prepare:
```
source install/env.sh

install/0-preparing/0-1-linux-config.sh
install/0-preparing/0-2-install-kubelet.sh
install/0-preparing/0-3-install-cni.sh
install/0-preparing/0-4-i0-preparing/nstall-cfssl.sh

```

# generate config:
```
source install/env.sh

install/1-gen-cert/1-1-generate-etcd-ca.sh
install/1-gen-cert/1-2-generate-ca.sh
install/1-gen-cert/1-3-generate-front-proxy-ca.sh
install/1-gen-cert/1-4-generate-front-proxy-client.sh
install/1-gen-cert/1-5-cert-controller-manager.sh
install/1-gen-cert/1-6-cert-scheduler.sh
install/1-gen-cert/1-7-cert-admin.sh
install/1-gen-cert/1-8-cert-master-nodes.sh
install/1-gen-cert/1-9-cert-service-account.sh
install/1-gen-cert/1-10-cert-copy.sh
```

# install master services:
```
source install/env.sh

install/2-masters/2-1-gen-configs.sh
install/2-masters/2-2-gen-manifests.sh
install/2-masters/2-3-kubelet-services.sh
```


# bootstrap:
```
source install/env.sh

install/3-bootstrap/3-1-bootstrap-conf.sh
install/3-bootstrap/3-2-bootstrap-secret.sh
install/3-bootstrap/3-3-bootstrap-rbac.sh

```

