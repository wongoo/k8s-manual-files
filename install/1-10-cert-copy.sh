#!/bin/sh
#

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
    
