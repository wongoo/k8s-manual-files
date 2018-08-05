#!/bin/sh
#

# 此憑證將被用於 Authenticating Proxy 的功能上，而該功能主要是提供 API Aggregation 的認證
cfssl gencert -initca front-proxy-ca-csr.json | cfssljson -bare ${PKI_DIR}/front-proxy-ca

