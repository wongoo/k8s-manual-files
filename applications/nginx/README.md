
```bash

kubectl apply -f nginx-deployment.yaml

kubectl expose deployment nginx-app --type=NodePort --port=80

kubectl exec -it nginx-app sh

minikube service nginx-app

minikube dashboard

```
