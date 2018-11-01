#!/bin/sh


sed -i 's/192.168.0.0\/16/10.244.0.0\/16/g' cni/calico/v3.3/calico.yaml
$ kubectl -f cni/calico/v3.3/

