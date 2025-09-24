{{ define "incloud-web-resources.sidebar.menu.items.instance" }}
{{ if (include "incloud-web-resources.sidebar.menu.items.instance-items" . | trim) }}
{{ include "incloud-web-resources.sidebar.menu.items.instance-items" . }}
{{ else }}
[]
{{ end }}
{{ end }}

{{ define "incloud-web-resources.sidebar.menu.items.instance-items" }}
{{ $sidebars := .Values.sidebars.instance }}
{{ $projRes := .Values.projectResource }}
{{ $instRes := .Values.instanceResource }}

{{- if $sidebars.customItems -}}
  {{- range $sidebars.customItems }}
{{ $sidebars.customItems | toYaml }}
  {{- end }}
{{- end -}}

{{ if not .Values.namespaceNavigation }}
{{ with $sidebars.projects }}
  {{ if .enabled }}
- children:
    - key: projects
      label: Projects
      link: /openapi-ui/{clusterName}/{namespace}/{{ $projRes.apiGroup }}/{{ $projRes.apiVersion }}/{{ $projRes.resourceName }}
  key: projects
  label: Projects
  {{ end }}
{{ end }}

{{ with $sidebars.instances }}
  {{ if .enabled }}
- children:
    - key: instances
      label: Instances
      link: /openapi-ui/{clusterName}/{namespace}/api-table/{{ $instRes.apiGroup }}/{{ $instRes.apiVersion }}/{{ $instRes.resourceName }}
  key: instances
  label: Instances
  {{ end }}
{{ end }}
{{ end }}

{{ if .Values.addons.argocd.enabled }}
{{ with $sidebars.argocd }}
  {{ if .enabled }}
- children:
    {{ if .items.applications }}
    - key: argocd-application
      label: Applications
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/argoproj.io/v1alpha1/applications
    {{ end }}
    {{ if .items.applicationset }}
    - key: argocd-applicationset
      label: ApplicationSets
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/argoproj.io/v1alpha1/applicationsets
    {{ end }}
    {{ if .items.appprojects }}
    - key: argocd-appprojects
      label: Projects
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/argoproj.io/v1alpha1/appprojects
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  key: argocd
  label: Argocd
  {{ end }}
{{ end }}
{{ end }}

{{ if .Values.addons.hbf.enabled }}
{{ with $sidebars.hbf }}
  {{ if .enabled }}
- key: hbf
  label: HBF
  children:
    {{ if .items.hosts }}
    - key: hbf-hosts
      label: Hosts
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/hosts"
    {{ end }}
    {{ if .items.hostbindings }}
    - key: hbf-hostbindings
      label: HostBindings
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/hostbindings"
    {{ end }}
    {{ if .items.networks }}
    - key: hbf-networks
      label: Networks
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/networks"
    {{ end }}
    {{ if .items.addressgroups }}
    - key: hbf-addressgroups
      label: AddressGroups
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/addressgroups"
    {{ end }}
    {{ if .items.networkbindings }}
    - key: hbf-networkbindings
      label: NetworkBindings
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/networkbindings"
    {{ end }}
    {{ if .items.ieagagrules }}
    - key: hbf-ieagagrules
      label: RuleAG2AG
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/ieagagrules"
    {{ end }}
    {{ if .items.services }}
    - key: hbf-services
      label: Services
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/services"
    {{ end }}
    {{ if .items.servicealiases }}
    - key: hbf-servicealiases
      label: ServiceAliases
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/servicealiases"
    {{ end }}
    {{ if .items.addressgroupbindings }}
    - key: hbf-addressgroupbindings
      label: AddressGroupBindings
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/addressgroupbindings"
    {{ end }}
    {{ if .items.rules2ses }}
    - key: hbf-rules2ses
      label: RuleS2S
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/rules2s"
    {{ end }}
    {{ if .items.addressgroupportmappings }}
    - key: hbf-addressgroupportmappings
      label: AddressGroupPortMappings
      link: "/openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/addressgroupportmappings"
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  {{ end }}
{{ end }}
{{ end }}

{{ with $sidebars.workloads }}
  {{ if .enabled }}
- children:
    {{ if .items.pods }}
    - key: pods
      label: Pods
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/pods
    {{ end }}
    {{ if .items.deployments }}
    - key: deployments
      label: Deployments
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/apps/v1/deployments
    {{ end }}
    {{ if .items.statefulsets }}
    - key: statefulsets
      label: Statefulsets
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/apps/v1/statefulsets
    {{ end }}
    {{ if .items.secrets }}
    - key: secrets
      label: Secrets
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/secrets
    {{ end }}
    {{ if .items.configmaps }}
    - key: configmaps
      label: ConfigMaps
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/configmaps
    {{ end }}
    {{ if .items.cronjobs }}
    - key: cronjobs
      label: CronJobs
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/batch/v1/cronjobs
    {{ end }}
    {{ if .items.jobs }}
    - key: jobs
      label: Jobs
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/batch/v1/jobs
    {{ end }}
    {{ if .items.daemonsets }}
    - key: daemonsets
      label: Daemonsets
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/apps/v1/daemonsets
    {{ end }}
    {{ if .items.replicasets }}
    - key: replicasets
      label: ReplicaSets
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/apps/v1/replicasets
    {{ end }}
    {{ if .items.replicationcontrollers }}
    - key: replicationcontrollers
      label: ReplicationControllers
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/replicationcontrollers
    {{ end }}
    {{ if .items.horizontalpodautoscalers }}
    - key: horizontalpodautoscalers
      label: HorizontalPodAutoscalers
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/autoscaling/v2/horizontalpodautoscalers
    {{ end }}
    {{ if .items.poddisruptionbudgets }}
    - key: poddisruptionbudgets
      label: PodDisruptionBudgets
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/policy/v1/poddisruptionbudgets
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  key: workloads
  label: Workloads
  {{ end }}
{{ end }}

{{ with $sidebars.networking }}
  {{ if .enabled }}
- children:
    {{ if .items.services }}
    - key: services
      label: Services
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/services
    {{ end }}
    {{ if .items.networkpolicies }}
    - key: networkpolicies
      label: NetworkPolicies
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/networking.k8s.io/v1/networkpolicies
    {{ end }}
    {{ if .items.ingresses }}
    - key: ingresses
      label: Ingresses
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/networking.k8s.io/v1/ingresses
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  key: networking
  label: Networking
  {{ end }}
{{ end }}

{{ with $sidebars.storage }}
  {{ if .enabled }}
- children:
    {{ if .items.persistentvolumes }}
    - key: persistentvolumes
      label: PersistentVolumes
      link: /openapi-ui/{clusterName}/builtin-table/persistentvolumes
    {{ end }}
    {{ if .items.persistentvolumeclaims }}
    - key: persistentvolumeclaims
      label: PersistentVolumeClaims
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/persistentvolumeclaims
    {{ end }}
    {{ if .items.storageclasses }}
    - key: storageclasses
      label: StorageClasses
      link: /openapi-ui/{clusterName}/api-table/storage.k8s.io/v1/storageclasses
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  key: storage
  label: Storage
  {{ end }}
{{ end }}

{{ with $sidebars.compute }}
  {{ if .enabled }}
- children:
    {{ if .items.nodes }}
    - key: nodes
      label: Nodes
      link: /openapi-ui/{clusterName}/builtin-table/nodes
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  key: compute
  label: Compute
  {{ end }}
{{ end }}

{{ with $sidebars.usermanagement }}
  {{ if .enabled }}
- children:
    {{ if .items.serviceaccounts }}
    - key: serviceaccounts
      label: ServiceAccounts
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/serviceaccounts
    {{ end }}
    {{ if .items.roles }}
    - key: roles
      label: Roles
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/rbac.authorization.k8s.io/v1/roles
    {{ end }}
    {{ if .items.rolebindings }}
    - key: rolebindings
      label: RoleBindings
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/api-table/rbac.authorization.k8s.io/v1/rolebindings
    {{ end }}
    {{ if .items.clusterroles }}
    - key: clusterroles
      label: ClusterRoles
      link: /openapi-ui/{clusterName}/api-table/rbac.authorization.k8s.io/v1/clusterroles
    {{ end }}
    {{ if .items.clusterrolebindings }}
    - key: clusterrolebindings
      label: ClusterRoleBindings
      link: /openapi-ui/{clusterName}/api-table/rbac.authorization.k8s.io/v1/clusterrolebindings
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  key: usermanagement
  label: User Management
  {{ end }}
{{ end }}

{{ with $sidebars.administration }}
  {{ if .enabled }}
- children:
    {{ if .items.namespaces }}
    - key: namespaces
      label: Namespaces
      link: /openapi-ui/{clusterName}/builtin-table/namespaces
    {{ end }}
    {{ if .items.limitranges }}
    - key: limitranges
      label: LimitRanges
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/limitranges
    {{ end }}
    {{ if .items.resourcequotas }}
    - key: resourcequotas
      label: ResourceQuotas
      link: /openapi-ui/{clusterName}/{namespace}/{syntheticProject}/builtin-table/resourcequotas
    {{ end }}
    {{ if .items.customresourcedefinitions }}
    - key: customresourcedefinitions
      label: CustomResourceDefinitions
      link: /openapi-ui/{clusterName}/api-table/apiextensions.k8s.io/v1/customresourcedefinitions
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  key: administration
  label: Administration
  {{ end }}
{{ end }}
{{ end }}
