#!/bin/bash

set -euo pipefail

clang -O2 -target bpf -c pkts.c -o pkts.o

function genyaml {
    file="$1"
    name="${file}-config"
    object="${file}.o"
    resource="${file}-bpf"
    namespace="${file}-ns"

    cat > ${file}.yaml <<EOL
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${namespace}
---
apiVersion: bpf.sh/v1alpha1
kind: BPF
metadata:
  name: ${resource}
  namespace: ${namespace}
spec:
  program:
    valueFrom:
      configMapKeyRef:
        name: ${name}
        key: ${object}
---
EOL
    kubectl create configmap --from-file ${object} ${name} -o yaml -n ${namespace} --dry-run >> ${file}.yaml
}

genyaml pkts
