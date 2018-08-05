
docker pull quay.io/coreos/etcd:v3.3.8
docker pull docker.io/haproxy:1.7-alpine
docker pull docker.io/osixia/keepalived:1.4.5

# docker pull k8s.gcr.io/kube-apiserver-amd64:v1.11.1
# docker pull k8s.gcr.io/kube-controller-manager-amd64:v1.11.1
# docker pull k8s.gcr.io/kube-scheduler-amd64:v1.11.1


# 注：如果你会科学上网，可以不做这一步
# 以下通过添加tag将房屋gcr.io的镜像转到房屋从aliyuncs下载的镜像
# aliyun docker hub: https://dev.aliyun.com/search.html?spm=5176.1972344.0.1.79a95aaaF5Nzqy

docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.11.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:v1.11.1 k8s.gcr.io/kube-apiserver-amd64:v1.11.1


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.11.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:v1.11.1 k8s.gcr.io/kube-controller-manager-amd64:v1.11.1


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.11.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:v1.11.1 k8s.gcr.io/kube-scheduler-amd64:v1.11.1

docker images
