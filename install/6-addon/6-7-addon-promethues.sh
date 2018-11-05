#!/bin/sh

kubectl apply -f addons/prometheus/
kubectl apply -f addons/prometheus/operator/

# 這邊要等 operator 起來並建立好 CRDs 才能進行
kubectl apply -f addons/prometheus/alertmanater/
kubectl apply -f addons/prometheus/node-exporter/
kubectl apply -f addons/prometheus/kube-state-metrics/
kubectl apply -f addons/prometheus/grafana/
kubectl apply -f addons/prometheus/kube-service-discovery/
kubectl apply -f addons/prometheus/prometheus/
kubectl apply -f addons/prometheus/servicemonitor/

kubectl -n monitoring get po,svc,ing

