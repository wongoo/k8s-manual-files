
# k8s v1.12.2
sed -i "" -e "s/v1.12.2/v1.12.2/g" **/*.sh **/*.md **/*.yml **/*.conf

# quay.io/calico/ctl:v3.1.3
sed -i "" -e "s/v3.1.3/v3.3.0/g" cni/calico/v3.3/calicoctl.yml

# etcd 3.2.24
# check the latest verson: https://kubernetes.io/docs/setup/release/notes/
sed -i "" -e "s/v3.3.8/v3.2.24/g" master/manifests/etcd.yml hack/docker-images-master.sh

# haproxy:1.8-alpine
# https://hub.docker.com/_/haproxy/
sed -i "" -e "s#haproxy:1.7-alpine#haproxy:1.8-alpine#g"  master/manifests/haproxy.yml hack/docker-proxy.sh 

# keepalived:1.4.5
# https://hub.docker.com/r/osixia/keepalived/tags/
sed -i "" -e "s#keepalived:1.4.5#keepalived:1.4.5#g"  master/manifests/keepalived.yml hack/docker-proxy.sh 

# cni-plugins
sed -i "" -e "s#v0.7.2#v0.7.2#g" hack/*.sh install/0-preparing/0-3-install-cni.sh



