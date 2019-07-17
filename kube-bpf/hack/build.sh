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
    namespace="${file}-ns"

    cat > "${output_dir}/${file}.yaml" <<EOL
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
    kubectl create configmap --from-file "${output_dir}/${object}" ${name} -o yaml -n ${namespace} --dry-run >> "${output_dir}/${file}.yaml"
}

genyaml $program
