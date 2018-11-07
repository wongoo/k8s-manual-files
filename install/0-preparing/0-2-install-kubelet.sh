#!/bin/sh
#

# darwin/amd64
export KUBE_URL=https://storage.googleapis.com/kubernetes-release/release/${K8S_VERSION}/bin/linux/amd64
curl -O ${KUBE_URL}/kubelet 
curl -O ${KUBE_URL}/kubectl

chmod +x kube*

cp kubelet /usr/local/bin/kubelet
cp kubectl /usr/local/bin/kubectl

for NODE in $K8S_ALL; do
    scp kubelet $NODE:/usr/local/bin/kubelet
    scp kubectl $NODE:/usr/local/bin/kubectl

    ssh $NODE "chmod +x /usr/local/bin/kube*"
done
