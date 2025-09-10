{{- define "incloud-web-resources.sidebar.menu.items.namespaced" -}}
{{- if .Values.addons.argocd.enabled -}}
- children:
    - key: argocd-application
      label: Applications
      link: /openapi-ui/{clusterName}/{namespace}/api-table/argoproj.io/v1alpha1/applications
    - key: argocd-applicationset
      label: ApplicationSets
      link: /openapi-ui/{clusterName}/{namespace}/api-table/argoproj.io/v1alpha1/applicationsets
    - key: argocd-appprojects
      label: Projects
      link: /openapi-ui/{clusterName}/{namespace}/api-table/argoproj.io/v1alpha1/appprojects
  key: argocd
  label: Argocd
{{- end }}

{{- if .Values.addons.hbf.enabled }}
- key: hbf
  label: HBF
  children:
    - key: hbf-hosts
      label: Hosts
      link: "/openapi-ui/{clusterName}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/hosts"
    - key: hbf-hostbindings
      label: HostBindings
      link: "/openapi-ui/{clusterName}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/hostbindings"
    - key: hbf-networks
      label: Networks
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/networks"
    - key: hbf-addressgroups
      label: AddressGroups
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/addressgroups"
    - key: hbf-networkbindings
      label: NetworkBindings
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/networkbindings"
    - key: hbf-ieagagrules
      label: RuleAG2AG
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/ieagagrules"
    - key: hbf-services
      label: Services
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/services"
    - key: hbf-servicealiases
      label: ServiceAliases
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/servicealiases"
    - key: hbf-addressgroupbindings
      label: AddressGroupBindings
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/addressgroupbindings"
    - key: hbf-rules2ses
      label: RuleS2S
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/rules2s"
    - key: hbf-addressgroupportmappings
      label: AddressGroupPortMappings
      link: "/openapi-ui/{clusterName}/{namespace}/api-table/netguard.sgroups.io/{{ .Values.addons.hbf.apiVersion }}/addressgroupportmappings"
{{- end }}


- children:
    - key: pods
      label: Pods
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/pods
    - key: deployments
      label: Deployments
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps/v1/deployments
    - key: statefulsets
      label: Statefulsets
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps/v1/statefulsets
    - key: secrets
      label: Secrets
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/secrets
    - key: configmaps
      label: ConfigMaps
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/configmaps
    - key: cronjobs
      label: CronJobs
      link: /openapi-ui/{clusterName}/{namespace}/api-table/batch/v1/cronjobs
    - key: jobs
      label: Jobs
      link: /openapi-ui/{clusterName}/{namespace}/api-table/batch/v1/jobs
    - key: daemonsets
      label: Daemonsets
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps/v1/daemonsets
    - key: replicasets
      label: ReplicaSets
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps/v1/replicasets
    - key: replicationcontrollers
      label: ReplicationControllers
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/replicationcontrollers
    - key: horizontalpodautoscalers
      label: HorizontalPodAutoscalers
      link: /openapi-ui/{clusterName}/{namespace}/api-table/autoscaling/v2/horizontalpodautoscalers
    - key: poddisruptionbudgets
      label: PodDisruptionBudgets
      link: /openapi-ui/{clusterName}/{namespace}/api-table/policy/v1/poddisruptionbudgets
  key: workloads
  label: Workloads
- children:
    - key: services
      label: Services
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/services
    - key: networkpolicies
      label: NetworkPolicies
      link: /openapi-ui/{clusterName}/{namespace}/api-table/networking.k8s.io/v1/networkpolicies
    - key: ingresses
      label: Ingresses
      link: /openapi-ui/{clusterName}/{namespace}/api-table/networking.k8s.io/v1/ingresses
  key: networking
  label: Networking
- children:
    - key: persistentvolumes
      label: PersistentVolumes
      link: /openapi-ui/{clusterName}/builtin-table/persistentvolumes
    - key: persistentvolumeclaims
      label: PersistentVolumeClaims
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/persistentvolumeclaims
    - key: storageclasses
      label: StorageClasses
      link: /openapi-ui/{clusterName}/api-table/storage.k8s.io/v1/storageclasses
  key: storage
  label: Storage
- children:
    - key: nodes
      label: Nodes
      link: /openapi-ui/{clusterName}/builtin-table/nodes
  key: compute
  label: Compute
- children:
    - key: groups
      label: ServiceAccounts
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/serviceaccounts
    - key: roles
      label: Roles
      link: /openapi-ui/{clusterName}/{namespace}/api-table/rbac.authorization.k8s.io/v1/roles
    - key: rolebindings
      label: RoleBindings
      link: /openapi-ui/{clusterName}/{namespace}/api-table/rbac.authorization.k8s.io/v1/rolebindings
    - key: clusterroles
      label: ClusterRoles
      link: /openapi-ui/{clusterName}/api-table/rbac.authorization.k8s.io/v1/clusterroles
    - key: clusterrolebindings
      label: ClusterRoleBindings
      link: /openapi-ui/{clusterName}/api-table/rbac.authorization.k8s.io/v1/clusterrolebindings
  key: usermanagement
  label: User Management
- children:
    - key: namespaces
      label: Namespaces
      link: /openapi-ui/{clusterName}/builtin-table/namespaces
    - key: limitranges
      label: LimitRanges
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/limitranges
    - key: resourcequotas
      label: ResourceQuotas
      link: /openapi-ui/{clusterName}/{namespace}/builtin-table/resourcequotas
    - key: customresourcedefinitions
      label: CustomResourceDefinitions
      link: /openapi-ui/{clusterName}/api-table/apiextensions.k8s.io/v1/customresourcedefinitions
  key: administration
  label: Administration

{{- end }}
