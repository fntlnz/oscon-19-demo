#!/bin/bash

set -xeuo pipefail

program=$1
output_dir=$2

clang -O2 -target bpf -c "${program}.c" -o "${output_dir}/${program}.o"

function genyaml {
    file="$1"
    name="${file}-config"
    object="${file}.o"
    resource="${file}-bpf"

    cat > "${output_dir}/${file}.yaml" <<EOL
---
apiVersion: bpf.sh/v1alpha1
kind: BPF
metadata:
  name: ${resource}
spec:
  program:
    valueFrom:
      configMapKeyRef:
        name: ${name}
        key: ${object}
---
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: ${resource}
  app: ${resource}
labels:
  team: bpf
spec:
  selector:
    matchLabels:
      app: bpf-${resource}
  endpoints:
  - port: bpf
---
EOL
    kubectl create configmap --from-file "${output_dir}/${object}" ${name} -o yaml --dry-run >> "${output_dir}/${file}.yaml"
}

genyaml $program
