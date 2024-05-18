
.PHONY: test
test: export KUBEBUILDER_CONTROLPLANE_STOP_TIMEOUT = 10m
test: | $(NEEDS_ETCD) $(NEEDS_KUBE-APISERVER) $(NEEDS_GOTESTSUM) $(ARTIFACTS)
	$(GOTESTSUM) \
		--junitfile $(PWD)/$(ARTIFACTS)/junit-conformance-tests.xml \
		--format testdox \
		-- \
		-timeout 60m \
		-count 1 \
		-coverprofile=$(PWD)/$(ARTIFACTS)/cover.out \
		.