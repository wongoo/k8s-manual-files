
prepare:
```
source install/0-0-env.sh

install/0-1-linux-config.sh
install/0-2-install-kubelet.sh
install/0-3-install-cni.sh
install/0-4-install-cfssl.sh

```

generate config:
```
source install/0-0-env.sh

install/1-1-generate-etcd-ca.sh
install/1-2-generate-ca.sh
install/1-3-generate-front-proxy-ca.sh
install/1-4-generate-front-proxy-client.sh
install/1-5-cert-controller-manager.sh
install/1-6-cert-scheduler.sh
install/1-7-cert-admin.sh
install/1-8-cert-master-nodes.sh
install/1-9-cert-service-account.sh
install/1-10-cert-copy.sh
```
