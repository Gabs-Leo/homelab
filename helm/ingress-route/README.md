Removing the label below is necessary, the cluster can't access resources exposed by IngressRoutes otherwise.
```sh
kubectl label node tata-note node.kubernetes.io/exclude-from-external-load-balancers-
```