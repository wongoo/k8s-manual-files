# docker run --name etcd etcd:v3.3.8
# docker exec etcd /bin/sh -c "ETCDCTL_API=3 /usr/local/bin/etcdctl get foo"

./etcdctl  --ca-file=/etc/etcd/ssl/etcd-ca.pem --cert-file=/etc/etcd/ssl/etcd.pem  --key-file=/etc/etcd/ssl/etcd-key.pem get foo

