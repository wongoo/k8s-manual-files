#!/bin/sh
#

cfssl gencert \
  -ca=${PKI_DIR}/front-proxy-ca.pem \
  -ca-key=${PKI_DIR}/front-proxy-ca-key.pem \
  -config=pki/ca-config.json \
  -profile=kubernetes \
  pki/front-proxy-client-csr.json | cfssljson -bare ${PKI_DIR}/front-proxy-client

