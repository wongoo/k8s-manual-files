#!/bin/sh

CALICODIR=cni/calico/${K8S_CALICO_VERSION}/
mkdir -p "${CALICODIR}"

if [ -f ${CALICODIR}/calico.yaml ]; then
	echo "calico.yaml exists"
else
	PREDIR=$(pwd)
	cd ${CALICODIR}
	curl -O https://docs.projectcalico.org/${K8S_CALICO_VERSION}/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
	curl -O https://docs.projectcalico.org/${K8S_CALICO_VERSION}/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml
	curl -O https://docs.projectcalico.org/${K8S_CALICO_VERSION}/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calicoctl.yaml
	sed -i 's/192.168.0.0\/16/10.244.0.0\/16/g' calico.yaml
	cd ${PREDIR}
fi

# kubectl delete -f ${CALICODIR}
# sleep 5

kubectl apply -f ${CALICODIR}
echo "wait calico installation ..."
sleep 10

#  run calicoctl commands through the Pod using kubectl
kubectl exec -ti -n kube-system calicoctl -- /calicoctl get profiles -o wide

