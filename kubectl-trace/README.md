# Kubectl trace examples

## file opens

Show all the file being open in a specific node, named `ip-10-0-0-115.ec2.internal`.
```bash
kubectl trace run -e 'kprobe:do_sys_open { printf("%s: %s\n", comm, str(arg1)) }' ip-10-0-0-115.ec2.internal -a
```

## caturday

Install caturday

```
kubectl apply -f caturday.yaml
```

Do the port forwarding to see the cats on your local machine on port `8080`

```bash
kubectl port-forward deployment/caturday -n caturday :8080
```

Attach kubectl-trace to one of the caturday pods (change the name hereafter with one taken from `kubectl get pods -n caturday`).

This will trigger a print every time the Go function in the main package `counterValue` is called and will give its return value as a result along with the pid.
```bash
kubectl trace run -e 'uretprobe:/proc/$container_pid/exe:"main.counterValue" { printf("%d %d\n", pid, retval) }' pod/caturday-8475d9897d-gvtvh -a -n caturday
```

## flamegraph

You can plot two kinds of flamegraphs, from kernel level stack, taking in account kernel tasks and their structures and
from user level stacks, taking in account applications and their structures.

### cpu profiling sampling kernel stacks at 999 Hertz (samples per second):


```bash
kubectl trace run -a -e 'profile:hz:999 { @[kstack] = count() }' ip-10-0-0-115.ec2.internal > stackfile
```

### cpu profiling user level stacks (of the caturday application) at 999 Hertz:

Again, we can reuse the caturday pod we extracted before to produce a user level stack of its process.
```bash
kubectl trace run -n caturday -a -e  'profile:hz:999 /pid == $container_pid/ { @[ustack] = count(); }' pod/caturday-8475d9897d-gvtvh > stackfile
```

### plotting the flamegraph

```bash
git clone git@github.com:brendangregg/FlameGraph.git
cd FlameGraph
./stackcollapse-bpftrace.pl /vagrant/stackfile > stackfile-collapsed"
./flamegraph.pl stackfile-collapsed > stackfile.svg"
```
