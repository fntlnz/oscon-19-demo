.PHONY: build clean


build: _output/pkts.yaml

_output/pkts.yaml: _output
	hack/build.sh pkts _output

_output:
	mkdir -p _output

clean:
	rm -rf _output
