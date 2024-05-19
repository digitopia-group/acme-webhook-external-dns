# cert-manager - ExternalDNS webhook

This repo allows [cert-manager](https://github.com/cert-manager/cert-manager) to use [ExternalDNS](https://github.com/kubernetes-sigs/external-dns) to handle ACME challenges. 

## Requirements 

### ExternalDNS

The default configuration of ExternalDNS needs altering for this integration to function:
- TXT records are not managed by ExternalDNS by default, it requires an extra flag 
- The DNSEndpoint CRD is not enabled by default 

If you are deploying with the [official Helm chart](https://artifacthub.io/packages/helm/external-dns/external-dns) you can accomplish this by including this in your values file:

```yaml
extraArgs: 
  - --managed-record-types=A      # ┐
  - --managed-record-types=AAAA   # ├ Default values
  - --managed-record-types=CNAME  # ┘
  - --managed-record-types=TXT    # ─ New value

sources:
  - service # ┬ Default values
  - ingress # ┘
  - crd     # ─ New value
```

### cert-manager

Any supported version of cert-manager supports DNS webhooks, for documentation on installing cert-manager see the [official documentation](https://cert-manager.io/docs/installation/)

## Installing

TODO

## Usage

To configure an issuer to use ExternalDNS you just specify the group and solver name within the Issuer or ClusterIssuer config:

```yaml
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: example-issuer
spec:
  acme:
   ...
    solvers:
    - dns01:
        webhook:
          groupName: external-dns.acme.cert-manager.io
          solverName: external-dns
```