#!/bin/sh
#

export CFSSL_URL=https://pkg.cfssl.org/R1.2
wget ${CFSSL_URL}/cfssl_linux-amd64 -O /usr/local/bin/cfssl
wget ${CFSSL_URL}/cfssljson_linux-amd64 -O /usr/local/bin/cfssljson
chmod +x /usr/local/bin/cfssl*

# for NODE in $K8S_ALL; do
#     scp /usr/local/bin/cfssl $NODE:/usr/local/bin/cfssl
#     scp /usr/local/bin/cfssljson $NODE:/usr/local/bin/cfssljson
#     ssh $NODE "chmod +x /usr/local/bin/cfssl*"
# done
