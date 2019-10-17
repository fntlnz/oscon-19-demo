# OSCON 2019 - eBPF-powered distributed Kubernetes performance analysis

This repository contains the code examples I used during OSCON 2019 for my talk titled "eBPF-powered distributed Kubernetes performance analysis".

You need a Kubernetes cluster to execute what's in here!

Folders explaination:

- [/kube-bpf](/kube-bpf): contains a program example to be used with [https://github.com/bpftools/kube-bpf](github.com/bpftools/kube-bpf).
- [/setup](/setup): contains the setup scripts to install prometheus and grafana to show the nice dashboards for kube-bpf
- [/kubectl-trace](/kubectl-trace): contains the examples I used to demo [https://github.com/iovisor/kubectl-trace](github.com/iovisor/kubectl-trace).

