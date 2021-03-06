# 注：如果你会科学上网，可以不做这一步
# 以下通过添加tag将gcr.io的镜像转到从aliyuncs下载的镜像
# aliyun docker hub: https://dev.aliyun.com/search.html?spm=5176.1972344.0.1.79a95aaaF5Nzqy

# gcr.io/google_containers/pause-amd64:3.1 是POD默认的容器,可以通过kubelet启动参数--pod-infra-container-image指定.

for NODE in ${NODES}; do
   ssh ${NODE} "docker pull quay.io/coreos/etcd:${K8S_ETCD_VERSION};
   		docker pull haproxy:latest;
		docker pull osixia/keepalived:latest;
		docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:${K8S_VERSION};
		docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver-amd64:${K8S_VERSION} k8s.gcr.io/kube-apiserver-amd64:${K8S_VERSION};
		docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:${K8S_VERSION};
		docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager-amd64:${K8S_VERSION} k8s.gcr.io/kube-controller-manager-amd64:${K8S_VERSION};
		docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:${K8S_VERSION};
		docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler-amd64:${K8S_VERSION} k8s.gcr.io/kube-scheduler-amd64:${K8S_VERSION};
		docker images"
done
