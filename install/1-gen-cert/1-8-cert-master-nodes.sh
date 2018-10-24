#!/bin/sh
#

for NODE in $K8S_MASTERS; do
    echo "--- $NODE ---"
    cp pki/kubelet-csr.json pki/kubelet-$NODE-csr.json;
    sed -i "s/\$NODE/$NODE/g" pki/kubelet-$NODE-csr.json;

    cfssl gencert \
      -ca=${PKI_DIR}/ca.pem \
      -ca-key=${PKI_DIR}/ca-key.pem \
      -config=pki/ca-config.json \
      -hostname=$NODE \
      -profile=kubernetes \
      pki/kubelet-$NODE-csr.json | cfssljson -bare ${PKI_DIR}/kubelet-$NODE;

    rm -f pki/kubelet-$NODE-csr.json
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
