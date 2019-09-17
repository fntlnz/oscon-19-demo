kubectl port-forward --address 0.0.0.0 svc/prometheus 9090:9090 &
kubectl port-forward --address 0.0.0.0 svc/grafana 3000:3000