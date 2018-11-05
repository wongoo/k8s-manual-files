# docker pull k8s.gcr.io/kube-apiserver-amd64:v1.12.2
# docker pull k8s.gcr.io/kube-controller-manager-amd64:v1.12.2
# docker pull k8s.gcr.io/kube-scheduler-amd64:v1.12.2

# 注：如果你会科学上网，可以不做这一步
# 以下通过添加tag将gcr.io的镜像转到从aliyuncs下载的镜像
# aliyun docker hub: https://dev.aliyun.com/search.html?spm=5176.1972344.0.1.79a95aaaF5Nzqy

# gcr.io/google_containers/pause-amd64:3.1 是POD默认的容器,可以通过kubelet启动参数--pod-infra-container-image指定.

for NODE in ${NODES}; do
   ssh ${NODE} "docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1;
		docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.4;
		docker pull googlecontainer/defaultbackend-amd64:1.4;
		docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.12.2;
		docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.0;
		docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.0 k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0;
		docker pull quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.20.0;
		docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 k8s.gcr.io/pause-amd64:3.1;
		docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause-amd64:3.1 k8s.gcr.io/pause:3.1;
		docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy-amd64:v1.12.2 k8s.gcr.io/kube-proxy-amd64:v1.12.2;
		docker images"
done
