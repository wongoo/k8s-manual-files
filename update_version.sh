
FILES="**/*.sh **/*.md **/*.yml **/*.conf"

# k8s
sed -i "" -e "s/v1.11.1/v1.12.0/g" $(FILES)

# quay.io/calico/ctl:v3.1.3
sed -i "" -e "s/v3.1.3/v3.1.3/g" cni/calico/v3.1/calicoctl.yml

# etcd
# quay.io/coreos/etcd:v3.3.9
sed -i "" -e "s/v3.3.8/v3.3.9/g" master/manifests/etcd.yml hack/docker-proxy.sh

# haproxy:1.8-alpine
# https://hub.docker.com/_/haproxy/
sed -i "" -e "s#haproxy:1.7-alpine#haproxy:1.8-alpine#g"  master/manifests/haproxy.yml hack/docker-proxy.sh 

# keepalived:1.4.5
# https://hub.docker.com/r/osixia/keepalived/tags/
sed -i "" -e "s#keepalived:1.4.5#keepalived:1.4.5#g"  master/manifests/keepalived.yml hack/docker-proxy.sh 

# cni-plugins
sed -i "" -e "s#v0.6.0#v0.7.1#g" hack/*.sh install/0-preparing/0-3-install-cni.sh


