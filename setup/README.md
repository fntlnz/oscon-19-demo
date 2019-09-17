# Demo

1. Install Prometheus Operator

   ```console
   helm install stable/prometheus-operator
   ```

2. Apply the Prometheus YAML

    ```console
    kubectl apply -f prometheus.yaml
    ```

3. Apply the Grafana YAML

    ```console
    kubectl apply -f grafana.yaml
    ```

4. Apply the BPF service monitor YAML

    ```console
    kubectl apply -f bpf-servicemonitor.yaml
    ```

Finally, when you have deployed your BPF custom resource and want to play with the metrics it extracted, execute `forward.sh` to perform the port-forwarding on your localhost.