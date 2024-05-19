# acme-webhook-external-dns

<!-- see https://artifacthub.io/packages/helm/cert-manager/cert-manager-approver-policy for the rendered version -->

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

## Helm Values

<!-- AUTO-GENERATED -->

#### **http_proxy** ~ `string`

Configures the HTTP_PROXY environment variable where a HTTP proxy is required.

#### **https_proxy** ~ `string`

Configures the HTTPS_PROXY environment variable where a HTTP proxy is required.

#### **no_proxy** ~ `string`

Configures the NO_PROXY environment variable where a HTTP proxy is required, but certain domains should be excluded.

#### **replicaCount** ~ `number,string,null`
> Default value:
> ```yaml
> 1
> ```

Number of replicas of approver-policy to run.  
  
For example:  
 Use integer to set a fixed number of replicas

```yaml
replicaCount: 2
```

Use null, if you want to omit the replicas field and use the Kubernetes default value.

```yaml
replicaCount: null
```

Use a string if you want to insert a variable for post-processing of the rendered template.

```yaml
replicaCount: ${REPLICAS_OVERRIDE:=3}
```



#### **image.registry** ~ `string`

Target image registry. This value is prepended to the target image repository, if set.  
For example:

```yaml
registry: quay.io
repository: jetstack/cert-manager-approver-policy
```

#### **image.repository** ~ `string`
> Default value:
> ```yaml
> gchr.io/thatsmrtalbot/acme-webhook-external-dns
> ```

Target image repository.
#### **image.tag** ~ `string`

Override the image tag to deploy by setting this variable. If no value is set, the chart's appVersion is used.

#### **image.digest** ~ `string`

Target image digest. Override any tag, if set.  
For example:

```yaml
digest: sha256:0e072dddd1f7f8fc8909a2ca6f65e76c5f0d2fcfb8be47935ae3457e8bbceb20
```

#### **image.pullPolicy** ~ `string`
> Default value:
> ```yaml
> IfNotPresent
> ```

Kubernetes imagePullPolicy on Deployment.
#### **webhook.port** ~ `number`
> Default value:
> ```yaml
> 10250
> ```

The port that the webhook listens on.
#### **service.type** ~ `string`
> Default value:
> ```yaml
> ClusterIP
> ```

Webhook service type, can be ClusterIP, NodePort or LoadBalancer.
#### **service.port** ~ `number`
> Default value:
> ```yaml
> 443
> ```

Webhook service port.
#### **certManager.namespace** ~ `string`
> Default value:
> ```yaml
> cert-manager
> ```

cert-manager namespace, this is used to grant cert-manager permission to call this webhook.
#### **certManager.serviceAccountName** ~ `string`
> Default value:
> ```yaml
> cert-manager
> ```

cert-manager service account name, this is used to grant cert-manager permission to call this webhook.
#### **imagePullSecrets** ~ `array`
> Default value:
> ```yaml
> []
> ```

Optional secrets used for pulling the approver-policy container image.
#### **hostNetwork** ~ `bool`
> Default value:
> ```yaml
> false
> ```

Boolean value, expose pod on hostNetwork.  
Required when running a custom CNI in managed providers such as AWS EKS.  
  
For more information, see [AWS EKS](https://cert-manager.io/docs/installation/compatibility/#aws-eks).
#### **dnsPolicy** ~ `string`
> Default value:
> ```yaml
> ClusterFirst
> ```

This value may need to be changed if `hostNetwork: true`
#### **priorityClassName** ~ `string`
> Default value:
> ```yaml
> ""
> ```

Configure the priority class of the Pod.  
  
For more information, see:  
* [Guaranteed Scheduling For Critical Add-On Pods](https://kubernetes.io/docs/tasks/administer-cluster/guaranteed-scheduling-critical-addon-pods/)  
* [Protect Your Mission-Critical Pods From Eviction With PriorityClass](https://kubernetes.io/blog/2023/01/12/protect-mission-critical-pods-priorityclass/)  
  
For example:

```yaml
priorityClassName: system-cluster-critical
```


#### **affinity** ~ `object`
> Default value:
> ```yaml
> {}
> ```

A Kubernetes Affinity, if required. For more information, see [Affinity v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#affinity-v1-core).  
  
For example:

```yaml
affinity:
  nodeAffinity:
   requiredDuringSchedulingIgnoredDuringExecution:
     nodeSelectorTerms:
     - matchExpressions:
       - key: foo.bar.com/role
         operator: In
         values:
         - master
```
#### **nodeSelector** ~ `object`
> Default value:
> ```yaml
> kubernetes.io/os: linux
> ```

The nodeSelector on Pods tells Kubernetes to schedule Pods on the nodes with matching labels. For more information, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).

#### **tolerations** ~ `array`
> Default value:
> ```yaml
> []
> ```

A list of Kubernetes Tolerations, if required. For more information, see [Toleration v1 core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.27/#toleration-v1-core).  
  
For example:

```yaml
tolerations:
- key: foo.bar.com/role
  operator: Equal
  value: master
  effect: NoSchedule
```
#### **topologySpreadConstraints** ~ `array`
> Default value:
> ```yaml
> []
> ```

List of Kubernetes TopologySpreadConstraints. For more information, see:  
[Pod Topology Spread Constraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/).  
  
For example:

```yaml
topologySpreadConstraints:
- maxSkew: 2
  topologyKey: topology.kubernetes.io/zone
  whenUnsatisfiable: ScheduleAnyway
  labelSelector:
    matchLabels:
      app.kubernetes.io/name: cert-manager-approver-policy
      app.kubernetes.io/instance: cert-manager-approver-policy
```
#### **podDisruptionBudget.enabled** ~ `bool`
> Default value:
> ```yaml
> false
> ```

Enable or disable the PodDisruptionBudget resource.  
  
This prevents downtime during voluntary disruptions such as during a Node upgrade. For example, the PodDisruptionBudget blocks `kubectl drain` if it is used on the Node where the only remaining approver-policy  
Pod is currently running.
#### **podDisruptionBudget.minAvailable** ~ `number`

Configures the minimum available pods for disruptions.  
Cannot be used if `maxUnavailable` is set.

#### **podDisruptionBudget.maxUnavailable** ~ `number`

Configures the maximum unavailable pods for disruptions.  
Cannot be used if `minAvailable` is set.

#### **volumeMounts** ~ `array`
> Default value:
> ```yaml
> []
> ```

Optional extra volume mounts. Useful for mounting custom root CAs.  
  
For example:

```yaml
volumeMounts:
- name: my-volume-mount
  mountPath: /etc/approver-policy/secrets
```
#### **volumes** ~ `array`
> Default value:
> ```yaml
> []
> ```
#### **resources** ~ `object`
> Default value:
> ```yaml
> {}
> ```

Kubernetes pod resources.  
For more information, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).  
  
For example:

```yaml
resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi
```
#### **commonLabels** ~ `object`
> Default value:
> ```yaml
> {}
> ```

Allow custom labels to be placed on resources - optional.
#### **podAnnotations** ~ `object`
> Default value:
> ```yaml
> {}
> ```

Allow custom annotations to be placed on cert-manager-approver pod - optional.
#### **strategy** ~ `object`
> Default value:
> ```yaml
> {}
> ```

Deployment update strategy for the approver-policy Deployment.  
  
This could be needed when deploying approver-policy on each control-plane node and setting anti-affinities to forbid two pods on the same node. In this situation, default values of maxSurge (25% round up to next integer = 1) and maxUnavailable (25% round down to next integer = 0) block the rolling update as the new surge pod can't be scheduled on a control-plane node due to anti-affinities. Setting maxSurge to 0 and maxUnavailable to 1 would solve the problem.  
  
For example:

```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 0
    maxUnavailable: 1
```

For more information, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy).

<!-- /AUTO-GENERATED -->