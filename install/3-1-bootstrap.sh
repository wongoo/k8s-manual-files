#!/bin/sh
#

export TOKEN_ID=$(openssl rand 3 -hex)
export TOKEN_SECRET=$(openssl rand 8 -hex)
export BOOTSTRAP_TOKEN=${TOKEN_ID}.${TOKEN_SECRET}

# 建立 bootstrap 使用者的 kubeconfig 檔

kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/pki/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

kubectl config set-credentials tls-bootstrap-token-user \
  --token=${BOOTSTRAP_TOKEN} \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

kubectl config set-context tls-bootstrap-token-user@kubernetes \
  --cluster=kubernetes \
  --user=tls-bootstrap-token-user \
  --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf

kubectl config use-context tls-bootstrap-token-user@kubernetes \
    --kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf



# 建立 TLS Bootstrap Secret 來提供自動簽證使用

cat <<EOF | kubectl create -f -
apiVersion: v1
kind: Secret
metadata:
  name: bootstrap-token-${TOKEN_ID}
  namespace: kube-system
type: bootstrap.kubernetes.io/token
stringData:
  token-id: "${TOKEN_ID}"
  token-secret: "${TOKEN_SECRET}"
  usage-bootstrap-authentication: "true"
  usage-bootstrap-signing: "true"
  auth-extra-groups: system:bootstrappers:default-node-token
EOF
