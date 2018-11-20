#!/bin/sh

# ---------------
# see https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/calico

CALICODIR=cni/calico/${K8S_CALICO_VERSION}/
mkdir -p "${CALICODIR}"

if [ -f ${CALICODIR}/calico.yaml ]; then
	echo "calico.yaml exists"
else
	PREDIR=$(pwd)
	cd ${CALICODIR}
	
	# RBAC
	curl -O https://docs.projectcalico.org/${K8S_CALICO_VERSION}/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml

	# Calico
	curl -O https://docs.projectcalico.org/${K8S_CALICO_VERSION}/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
	sed -i 's/192.168.0.0\/16/10.244.0.0\/16/g' calico.yaml
	# sed -i 's/replicas: 0/replicas: 2/g' calico.yaml
	# sed -i 's/typha_service_name: "none"/typha_service_name: "calico-typha"/g' calico.yaml

	# calicoctl
	curl -O https://docs.projectcalico.org/${K8S_CALICO_VERSION}/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calicoctl.yaml

	cd ${PREDIR}
fi

# kubectl delete -f ${CALICODIR}
# sleep 5

kubectl apply -f ${CALICODIR}
echo "wait calico installation ..."
sleep 10

#----------------
# see https://docs.projectcalico.org/v2.6/getting-started/kubernetes/tutorials/using-calicoctl

#  run calicoctl commands through the Pod using kubectl
kubectl exec -ti -n kube-system calicoctl -- ping 10.96.0.1
kubectl exec -ti -n kube-system calicoctl -- /calicoctl get profiles -o wide


