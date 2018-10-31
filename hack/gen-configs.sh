#!/bin/sh
#
# Program: Generate etcd and haproxy config.
# History: 2018/07/07 k2r2.bai release.

set -eu

: ${NODES:="k8s-m1 k8s-m2 k8s-m3"}
: ${ETCD_TPML:="master/etc/etcd/config.yml"}
: ${HAPROXY_TPML:="master/etc/haproxy/haproxy.cfg"}

RED='\033[0;31m'
NC='\033[0m'

# generate envs
ETCD_SERVERS=""

HAPROXY_BACKENDS=""
for NODE in ${NODES}; do
  IP=$(ssh ${NODE} "ip route get 8.8.8.8" | awk '{print $NF; exit}')
  ETCD_SERVERS="${ETCD_SERVERS}${NODE}=https:\/\/${IP}:2380,"
  HAPROXY_BACKENDS="${HAPROXY_BACKENDS}    server ${NODE}-api ${IP}:5443 check\n"
done
echo ${HAPROXY_BACKENDS}

ETCD_SERVERS=$(echo ${ETCD_SERVERS} | sed 's/.$//')

# generating config
for NODE in ${NODES}; do
  echo "---------$NODE----------"
  IP=$(ssh ${NODE} "ip route get 8.8.8.8" | awk '{print $NF; exit}')
  ssh ${NODE} "mkdir -p /etc/etcd /etc/haproxy"

  # etcd
  scp ${ETCD_TPML} ${NODE}:/etc/etcd/config.yml
  ssh ${NODE} "sed -i 's/\${HOSTNAME}/${NODE}/g' /etc/etcd/config.yml;
               sed -i 's/\${PUBLIC_IP}/${IP}/g' /etc/etcd/config.yml;
               sed -i 's/\${ETCD_SERVERS}/${ETCD_SERVERS}/g' /etc/etcd/config.yml;"

  # haproxy
  # ------------NOTE: only install haproxy on client machine for VIP not support
  #scp ${HAPROXY_TPML} ${NODE}:/etc/haproxy/haproxy.cfg
  #ssh ${NODE} "sed -i 's/\${API_SERVERS}/${HAPROXY_BACKENDS}/g' /etc/haproxy/haproxy.cfg"

  echo "${RED}${NODE}${NC} config generated..."

  # echo "-----/etc/etcd/config.yml------"
  # ssh ${NODE} "cat /etc/etcd/config.yml"

  # echo "-----/etc/haproxy/haproxy.cfg------"
  # ssh ${NODE} "cat /etc/haproxy/haproxy.cfg"
done

# ---> for client
cp ${HAPROXY_TPML} /etc/haproxy/haproxy.cfg 2>&1 > /dev/null
/bin/sh -c "sed -i 's/\${API_SERVERS}/${HAPROXY_BACKENDS}/g' /etc/haproxy/haproxy.cfg"




