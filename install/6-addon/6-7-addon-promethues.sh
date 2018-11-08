#!/bin/sh

#------- see https://github.com/coreos/prometheus-operator/tree/master/contrib/kube-prometheus

mkdir -p temp
if [ -f temp/prometheus-operator ]; then
	echo "already download https://github.com/coreos/prometheus-operator.git"
else
	git clone --depth=1 https://github.com/coreos/prometheus-operator.git temp/prometheus-operator
fi

MDIR=temp/prometheus-operator/contrib/kube-prometheus/manifests
mkdir -p  ${MDIR}/operator
mv  ${MDIR}/0*.yaml  ${MDIR}/operator
ll ${MDIR}/operator

kubectl apply -f ${MDIR}/operator
kubectl -n monitoring get po,svc,ing

# 這邊要等 operator 起來並建立好 CRDs 才能進行
kubectl apply -f ${MDIR}
kubectl -n monitoring get po,svc,ing


# =====> Prometheus
kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090
# Then access via http://localhost:9090

# ====> Grafana
kubectl --namespace monitoring port-forward svc/grafana 3000
# Then access via http://localhost:3000 and use the default grafana user:password of admin:admin.

# ====> Alert Manager
kubectl --namespace monitoring port-forward svc/alertmanager-main 9093
# Then access via http://localhost:9093
