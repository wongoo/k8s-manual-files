
client: 10.204.0.4

use `ssh-keygen` generate `id_rsa`, `id_rsa.pub`

config /etc/hosts on all hosts(centos):
```
10.204.0.5 k8s-m1
10.204.0.6 k8s-m2
10.204.0.8 k8s-m3
10.204.0.9 k8s-n1
10.204.0.11 k8s-n2
10.204.0.12 k8s-n3
```

vip:
10.204.0.99 k8s_master

```
ifconfig eth0:0 10.204.0.99 netmask 255.255.255.0 up


# ifconfig eth0:0 down
```

add content of `id_rsa.pub` into file `/root/.ssh/authorized_keys` of all hosts.

install evn on client:
```
export K8S_MASTERS="k8s-m1 k8s-m2 k8s-m3"
export K8S_NODES="k8s-n1 k8s-n2 k8s-n3"
export K8S_ALL="$K8S_MASTERS $K8S_NODES"
export KUBE_APISERVER=https://10.204.0.99:6443

export K8S_DIR=/etc/kubernetes
export PKI_DIR=${K8S_DIR}/pki

for NODE in $K8S_ALL; do
    echo $NODE
done
```

disable firewalld,SELinux, config network, disable swap:
```
for NODE in $K8S_ALL; do
    ssh $NODE systemctl stop firewalld && systemctl disable firewalld

    ssh $NODE setenforce 0

    ssh $NODE "cat <<EOF > /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF"

    ssh $NODE "sysctl -p /etc/sysctl.d/k8s.conf"

    ssh $NODE "swapoff -a && sysctl -w vm.swappiness=0"
    ssh $NODE "sed '/swap.img/d' -i /etc/fstab"

done

```

download kubenet on all nodes:
```
export KUBE_URL=https://storage.googleapis.com/kubernetes-release/release/v1.11.1/bin/linux/amd64
wget ${KUBE_URL}/kubelet -O /usr/local/bin/kubelet
wget ${KUBE_URL}/kubectl -O /usr/local/bin/kubectl
chmod +x /usr/local/bin/kube*

for NODE in $K8S_ALL; do
    scp /usr/local/bin/kubelet $NODE:/usr/local/bin/kubelet
    scp /usr/local/bin/kubectl $NODE:/usr/local/bin/kubectl

    ssh $NODE "chmod +x /usr/local/bin/kube*"
done
```

download cni:
```
export CNI_URL=https://github.com/containernetworking/plugins/releases/download
wget "${CNI_URL}/v0.7.1/cni-plugins-amd64-v0.7.1.tgz"

for NODE in $K8S_ALL; do
    ssh $NODE "mkdir -p /opt/cni/bin"
    scp cni-plugins-amd64-v0.7.1.tgz $NODE:/opt/cni/bin/cni-plugins-amd64-v0.7.1.tgz
    ssh $NODE "cd /opt/cni/bin ; tar -xvf cni*.tgz"
done
```

install cfssl tool:
```
export CFSSL_URL=https://pkg.cfssl.org/R1.2
wget ${CFSSL_URL}/cfssl_linux-amd64 -O /usr/local/bin/cfssl
wget ${CFSSL_URL}/cfssljson_linux-amd64 -O /usr/local/bin/cfssljson
chmod +x /usr/local/bin/cfssl*

for NODE in $K8S_ALL; do
    scp /usr/local/bin/cfssl $NODE:/usr/local/bin/cfssl
    scp /usr/local/bin/cfssljson $NODE:/usr/local/bin/cfssljson
    ssh $NODE "chmod +x /usr/local/bin/cfssl*"
done
```


generate etcd ca:
```
export ETCD_PKI_DIR=/etc/etcd/ssl
mkdir -p ${ETCD_PKI_DIR}
cfssl gencert -initca etcd-ca-csr.json | cfssljson -bare ${ETCD_PKI_DIR}/etcd-ca

cfssl gencert \
  -ca=${ETCD_PKI_DIR}/etcd-ca.pem \
  -ca-key=${ETCD_PKI_DIR}/etcd-ca-key.pem \
  -config=ca-config.json \
  -hostname=127.0.0.1,10.204.0.5,10.204.0.6,10.204.0.8 \
  -profile=kubernetes \
  etcd-csr.json | cfssljson -bare ${ETCD_PKI_DIR}/etcd

ls ${ETCD_PKI_DIR}

for NODE in $K8S_MASTERS; do
    ssh ${NODE} "mkdir -p ${ETCD_PKI_DIR}"
    for FILE in etcd-ca-key.pem  etcd-ca.pem  etcd-key.pem  etcd.pem; do
      scp ${ETCD_PKI_DIR}/${FILE} ${NODE}:${ETCD_PKI_DIR}/${FILE}
    done
done

```

generate ca:
```
mkdir -p ${PKI_DIR}
cfssl gencert -initca ca-csr.json | cfssljson -bare ${PKI_DIR}/ca
ls ${PKI_DIR}/ca*
# /etc/kubernetes/pki/ca.csr  /etc/kubernetes/pki/ca-key.pem  /etc/kubernetes/pki/ca.pem

# 這邊-hostname的10.96.0.1是 Cluster IP 的 Kubernetes 端點;
# 10.204.0.99 為 VIP 位址;
# kubernetes.default為 Kubernetes 系統在 default namespace 自動建立的 API service domain name。
cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=ca-config.json \
  -hostname=10.96.0.1,10.204.0.99,127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  apiserver-csr.json | cfssljson -bare ${PKI_DIR}/apiserver

ls ${PKI_DIR}/apiserver*
# /etc/kubernetes/pki/apiserver.csr  /etc/kubernetes/pki/apiserver-key.pem  /etc/kubernetes/pki/apiserver.pem

```

Front Proxy Client:

```
# 此憑證將被用於 Authenticating Proxy 的功能上，而該功能主要是提供 API Aggregation 的認證
cfssl gencert -initca front-proxy-ca-csr.json | cfssljson -bare ${PKI_DIR}/front-proxy-ca

cfssl gencert \
  -ca=${PKI_DIR}/front-proxy-ca.pem \
  -ca-key=${PKI_DIR}/front-proxy-ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  front-proxy-client-csr.json | cfssljson -bare ${PKI_DIR}/front-proxy-client
```

Controller Manager:
```
cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  controller-manager-csr.json | cfssljson -bare ${PKI_DIR}/controller-manager

kubectl config set-cluster kubernetes \
    --certificate-authority=${PKI_DIR}/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=${K8S_DIR}/controller-manager.conf

kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=${PKI_DIR}/controller-manager.pem \
    --client-key=${PKI_DIR}/controller-manager-key.pem \
    --embed-certs=true \
    --kubeconfig=${K8S_DIR}/controller-manager.conf

kubectl config set-context system:kube-controller-manager@kubernetes \
    --cluster=kubernetes \
    --user=system:kube-controller-manager \
    --kubeconfig=${K8S_DIR}/controller-manager.conf

kubectl config use-context system:kube-controller-manager@kubernetes \
    --kubeconfig=${K8S_DIR}/controller-manager.conf
```

scheduler:
```
cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  scheduler-csr.json | cfssljson -bare ${PKI_DIR}/scheduler

kubectl config set-cluster kubernetes \
    --certificate-authority=${PKI_DIR}/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=${K8S_DIR}/scheduler.conf

kubectl config set-credentials system:kube-scheduler \
    --client-certificate=${PKI_DIR}/scheduler.pem \
    --client-key=${PKI_DIR}/scheduler-key.pem \
    --embed-certs=true \
    --kubeconfig=${K8S_DIR}/scheduler.conf

kubectl config set-context system:kube-scheduler@kubernetes \
    --cluster=kubernetes \
    --user=system:kube-scheduler \
    --kubeconfig=${K8S_DIR}/scheduler.conf

kubectl config use-context system:kube-scheduler@kubernetes \
    --kubeconfig=${K8S_DIR}/scheduler.conf
```

admin:
```
cfssl gencert \
  -ca=${PKI_DIR}/ca.pem \
  -ca-key=${PKI_DIR}/ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare ${PKI_DIR}/admin

kubectl config set-cluster kubernetes \
    --certificate-authority=${PKI_DIR}/ca.pem \
    --embed-certs=true \
    --server=${KUBE_APISERVER} \
    --kubeconfig=${K8S_DIR}/admin.conf

kubectl config set-credentials kubernetes-admin \
    --client-certificate=${PKI_DIR}/admin.pem \
    --client-key=${PKI_DIR}/admin-key.pem \
    --embed-certs=true \
    --kubeconfig=${K8S_DIR}/admin.conf

kubectl config set-context kubernetes-admin@kubernetes \
    --cluster=kubernetes \
    --user=kubernetes-admin \
    --kubeconfig=${K8S_DIR}/admin.conf

kubectl config use-context kubernetes-admin@kubernetes \
    --kubeconfig=${K8S_DIR}/admin.conf


```

master node :
```
for NODE in $K8S_MASTERS; do
    echo "--- $NODE ---"
    cp kubelet-csr.json kubelet-$NODE-csr.json;
    sed -i "s/\$NODE/$NODE/g" kubelet-$NODE-csr.json;

    cfssl gencert \
      -ca=${PKI_DIR}/ca.pem \
      -ca-key=${PKI_DIR}/ca-key.pem \
      -config=ca-config.json \
      -hostname=$NODE \
      -profile=kubernetes \
      kubelet-$NODE-csr.json | cfssljson -bare ${PKI_DIR}/kubelet-$NODE;

    rm -f kubelet-$NODE-csr.json
done

# 將 kubelet 憑證複製到所有master節點上：
for NODE in $K8S_MASTERS; do
    echo "--- $NODE ---"
    ssh ${NODE} "mkdir -p ${PKI_DIR}"

    scp ${PKI_DIR}/ca.pem ${NODE}:${PKI_DIR}/ca.pem
    scp ${PKI_DIR}/kubelet-$NODE-key.pem ${NODE}:${PKI_DIR}/kubelet-key.pem
    scp ${PKI_DIR}/kubelet-$NODE.pem ${NODE}:${PKI_DIR}/kubelet.pem

    rm -f ${PKI_DIR}/kubelet-$NODE-key.pem ${PKI_DIR}/kubelet-$NODE.pem
done

# 接著利用 kubectl 來產生 kubelet 的 kubeconfig 檔，這邊透過腳本來產生所有master節點的檔案：
for NODE in $K8S_MASTERS; do
    echo "--- $NODE ---"
    ssh ${NODE} "cd ${PKI_DIR} && \
      kubectl config set-cluster kubernetes \
        --certificate-authority=${PKI_DIR}/ca.pem \
        --embed-certs=true \
        --server=${KUBE_APISERVER} \
        --kubeconfig=${K8S_DIR}/kubelet.conf && \
      kubectl config set-credentials system:node:${NODE} \
        --client-certificate=${PKI_DIR}/kubelet.pem \
        --client-key=${PKI_DIR}/kubelet-key.pem \
        --embed-certs=true \
        --kubeconfig=${K8S_DIR}/kubelet.conf && \
      kubectl config set-context system:node:${NODE}@kubernetes \
        --cluster=kubernetes \
        --user=system:node:${NODE} \
        --kubeconfig=${K8S_DIR}/kubelet.conf && \
      kubectl config use-context system:node:${NODE}@kubernetes \
        --kubeconfig=${K8S_DIR}/kubelet.conf"
done
```

Service Account Key:
```
openssl genrsa -out ${PKI_DIR}/sa.key 2048
openssl rsa -in ${PKI_DIR}/sa.key -pubout -out ${PKI_DIR}/sa.pub
```

copy file:
```
rm -rf ${PKI_DIR}/*.csr \
    ${PKI_DIR}/scheduler*.pem \
    ${PKI_DIR}/controller-manager*.pem \
    ${PKI_DIR}/admin*.pem \
    ${PKI_DIR}/kubelet*.pem

for NODE in $K8S_MASTERS; do
    echo "--- $NODE ---"

    for FILE in $(ls ${PKI_DIR}); do
      scp ${PKI_DIR}/${FILE} ${NODE}:${PKI_DIR}/${FILE}
    done

    for FILE in admin.conf controller-manager.conf scheduler.conf; do
      scp ${K8S_DIR}/${FILE} ${NODE}:${K8S_DIR}/${FILE}
    done
done

```