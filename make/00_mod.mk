repo_name := github.com/thatsmrtlabot/acme-webhook-external-dns

kind_cluster_name :=acme-webhook-external-dns
kind_cluster_config := $(bin_dir)/scratch/kind_cluster.yaml

build_names := webhook

go_webhook_main_dir := .
go_webhook_mod_dir := .
go_webhook_ldflags := -X $(repo_name)/pkg/internal/version.AppVersion=$(VERSION) -X $(repo_name)/pkg/internal/version.GitCommit=$(GITCOMMIT)
oci_webhook_base_image_flavor := static
oci_webhook_image_name := ghcr.io/thatsmrtalbot/acme-webhook-external-dns
oci_webhook_image_tag := $(VERSION)
oci_webhook_image_name_development := cert-manager.local/acme-webhook-external-dns

deploy_name := acme-webhook-external-dns
deploy_namespace := cert-manager

golangci_lint_config := .golangci.yaml

