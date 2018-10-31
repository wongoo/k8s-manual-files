#!/bin/sh
#

export ETCD_PKI_DIR=/etc/etcd/ssl
mkdir -p ${ETCD_PKI_DIR}

#----------------------------
# 创建 ETC-CA 证书, 会产生：
# - etcd-ca-key:pem : ca私钥
# - etc-ca.pem： ca 证书

cfssl gencert -initca pki/etcd-ca-csr.json | cfssljson -bare ${ETCD_PKI_DIR}/etcd-ca

#---------------------------
# 产生 ETCD 证书
# - etcd-key.pem: etcd私钥
# - etcd.pem : etcd 证书

cfssl gencert \
  -ca=${ETCD_PKI_DIR}/etcd-ca.pem \
  -ca-key=${ETCD_PKI_DIR}/etcd-ca-key.pem \
  -config=pki/ca-config.json \
  -hostname=127.0.0.1,${K8S_M1_IP},${K8S_M2_IP},${K8S_M3_IP} \
  -profile=kubernetes \
  pki/etcd-csr.json | cfssljson -bare ${ETCD_PKI_DIR}/etcd

#---------------------------
ls ${ETCD_PKI_DIR}
# etcd-ca.csr  etcd-ca-key.pem  etcd-ca.pem  etcd.csr  etcd-key.pem  etcd.pem

# --- 查看证书请求文件信息
cfssl certinfo -csr ${ETCD_PKI_DIR}/etcd.csr
# --- 查看etcd证书信息
cfssl certinfo -cert ${ETCD_PKI_DIR}/etcd.pem

#---------------------------
# 将etcd相关证书文件复制到各个master节点
for NODE in $K8S_MASTERS; do
    ssh ${NODE} "mkdir -p ${ETCD_PKI_DIR}"
    for FILE in etcd-ca-key.pem  etcd-ca.pem  etcd-key.pem  etcd.pem; do
      scp ${ETCD_PKI_DIR}/${FILE} ${NODE}:${ETCD_PKI_DIR}/${FILE}
    done
done
