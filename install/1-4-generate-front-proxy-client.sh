#!/bin/sh
#

cfssl gencert \
  -ca=${PKI_DIR}/front-proxy-ca.pem \
  -ca-key=${PKI_DIR}/front-proxy-ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  front-proxy-client-csr.json | cfssljson -bare ${PKI_DIR}/front-proxy-client
