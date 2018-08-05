#!/bin/sh
#

openssl genrsa -out ${PKI_DIR}/sa.key 2048
openssl rsa -in ${PKI_DIR}/sa.key -pubout -out ${PKI_DIR}/sa.pub
    
