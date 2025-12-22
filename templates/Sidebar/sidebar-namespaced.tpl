# return [] if sidebebar items are empty
{{ define "incloud-web-resources.sidebar.menu.items.namespaced" }}
{{ if (include "incloud-web-resources.sidebar.menu.items.namespaced-items" . | trim) }}
{{ include "incloud-web-resources.sidebar.menu.items.namespaced-items" . }}
{{ else }}
[]
{{ end }}
{{ end }}

{{ define "incloud-web-resources.sidebar.menu.items.namespaced-items" }}
{{ $sidebars := .Values.sidebars.namespaced }}
{{ $projRes := .Values.projectResource }}
{{ $instRes := .Values.instanceResource }}

{{ with $sidebars.home }}
  {{ if .enabled }}
- children:
    {{ if .items.search }}
    - key: search
      label: Search
      link: /openapi-ui/{cluster}/search
    {{ end }}
    {{ if .items.projects }}
    - key: projects
      label: Projects
      link: /{{ $.Values.basePrefix }}/{cluster}/api-table/{{ $projRes.apiGroup }}/{{ $projRes.apiVersion }}/{{ $projRes.resourceName }}
    {{ end }}
    {{ if .items.instances }}
    - key: instances
      label: Instances
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/{{ $instRes.apiGroup }}/{{ $instRes.apiVersion }}/{{ $instRes.resourceName }}
    {{ end }}
  key: home
  label: Home
  {{ end }}
{{ end }}

{{- if $sidebars.customItems -}}
  {{- range $sidebars.customItems }}
{{ $sidebars.customItems | toYaml }}
  {{- end }}
{{- end -}}

{{ if .Values.addons.argocd.enabled }}
{{ with $sidebars.argocd }}
  {{ if .enabled }}
- children:
    {{ if .items.applications }}
    - key: argocd-application
      label: Applications
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/argoproj.io/v1alpha1/applications
    {{ end }}
    {{ if .items.applicationset }}
    - key: argocd-applicationset
      label: ApplicationSets
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/argoproj.io/v1alpha1/applicationsets
    {{ end }}
    {{ if .items.appprojects }}
    - key: argocd-appprojects
      label: Projects
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/argoproj.io/v1alpha1/appprojects
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
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/hosts?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.networks }}
    - key: hbf-networks
      label: Networks
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/networks?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.addressgroups }}
    - key: hbf-addressgroups
      label: AddressGroups
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/addressgroups?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.services }}
    - key: hbf-services
      label: Services
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/services?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.svcsvcrules }}
    - key: hbf-svcsvcrules
      label: SvcSvcRules
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/svcsvcrules?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.svcfqdnrules }}
    - key: hbf-svcfqdnrules
      label: SvcFqdnRules
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/svcfqdnrules?resources=/v1/namespaces"
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  {{ end }}
{{ end }}

{{ with $sidebars.hbfSystem }}
  {{ if .enabled }}
- key: hbfSystem
  label: HBF System
  children:
    {{ if .items.hostbindings }}
    - key: hbf-hostbindings
      label: HostBindings
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/hostbindings?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.networkbindings }}
    - key: hbf-networkbindings
      label: NetworkBindings
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/networkbindings?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.addressgroupbindings }}
    - key: hbf-addressgroupbindings
      label: AddressGroupBindings
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/addressgroupbindings?resources=/v1/namespaces"
    {{ end }}
    {{ if .items.addressgroupportmappings }}
    - key: hbf-addressgroupportmappings
      label: AddressGroupPortMappings
      link: "/{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/netguard.sgroups.io/{{ $.Values.addons.hbf.apiVersion }}/addressgroupportmappings?resources=/v1/namespaces"
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
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/pods?resources=metrics.k8s.io/v1beta1/pods
    {{ end }}
    {{ if .items.deployments }}
    - key: deployments
      label: Deployments
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/apps/v1/deployments
    {{ end }}
    {{ if .items.statefulsets }}
    - key: statefulsets
      label: Statefulsets
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/apps/v1/statefulsets
    {{ end }}
    {{ if .items.secrets }}
    - key: secrets
      label: Secrets
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/secrets
    {{ end }}
    {{ if .items.configmaps }}
    - key: configmaps
      label: ConfigMaps
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/configmaps
    {{ end }}
    {{ if .items.cronjobs }}
    - key: cronjobs
      label: CronJobs
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/batch/v1/cronjobs
    {{ end }}
    {{ if .items.jobs }}
    - key: jobs
      label: Jobs
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/batch/v1/jobs
    {{ end }}
    {{ if .items.daemonsets }}
    - key: daemonsets
      label: Daemonsets
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/apps/v1/daemonsets
    {{ end }}
    {{ if .items.replicasets }}
    - key: replicasets
      label: ReplicaSets
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/apps/v1/replicasets
    {{ end }}
    {{ if .items.replicationcontrollers }}
    - key: replicationcontrollers
      label: ReplicationControllers
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/replicationcontrollers
    {{ end }}
    {{ if .items.horizontalpodautoscalers }}
    - key: horizontalpodautoscalers
      label: HorizontalPodAutoscalers
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/autoscaling/v2/horizontalpodautoscalers
    {{ end }}
    {{ if .items.poddisruptionbudgets }}
    - key: poddisruptionbudgets
      label: PodDisruptionBudgets
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/policy/v1/poddisruptionbudgets
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
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/services
    {{ end }}
    {{ if .items.networkpolicies }}
    - key: networkpolicies
      label: NetworkPolicies
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/networking.k8s.io/v1/networkpolicies
    {{ end }}
    {{ if .items.ingresses }}
    - key: ingresses
      label: Ingresses
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/networking.k8s.io/v1/ingresses
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
      link: /{{ $.Values.basePrefix }}/{cluster}/builtin-table/persistentvolumes
    {{ end }}
    {{ if .items.persistentvolumeclaims }}
    - key: persistentvolumeclaims
      label: PersistentVolumeClaims
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/persistentvolumeclaims
    {{ end }}
    {{ if .items.storageclasses }}
    - key: storageclasses
      label: StorageClasses
      link: /{{ $.Values.basePrefix }}/{cluster}/api-table/storage.k8s.io/v1/storageclasses
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
      link: /{{ $.Values.basePrefix }}/{cluster}/builtin-table/nodes?resources=metrics.k8s.io/v1beta1/nodes
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
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/serviceaccounts
    {{ end }}
    {{ if .items.roles }}
    - key: roles
      label: Roles
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/rbac.authorization.k8s.io/v1/roles
    {{ end }}
    {{ if .items.rolebindings }}
    - key: rolebindings
      label: RoleBindings
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/api-table/rbac.authorization.k8s.io/v1/rolebindings
    {{ end }}
    {{ if .items.clusterroles }}
    - key: clusterroles
      label: ClusterRoles
      link: /{{ $.Values.basePrefix }}/{cluster}/api-table/rbac.authorization.k8s.io/v1/clusterroles
    {{ end }}
    {{ if .items.clusterrolebindings }}
    - key: clusterrolebindings
      label: ClusterRoleBindings
      link: /{{ $.Values.basePrefix }}/{cluster}/api-table/rbac.authorization.k8s.io/v1/clusterrolebindings
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
      link: /{{ $.Values.basePrefix }}/{cluster}/builtin-table/namespaces
    {{ end }}
    {{ if .items.limitranges }}
    - key: limitranges
      label: LimitRanges
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/limitranges
    {{ end }}
    {{ if .items.resourcequotas }}
    - key: resourcequotas
      label: ResourceQuotas
      link: /{{ $.Values.basePrefix }}/{cluster}/{namespace}/builtin-table/resourcequotas
    {{ end }}
    {{ if .items.customresourcedefinitions }}
    - key: customresourcedefinitions
      label: CustomResourceDefinitions
      link: /{{ $.Values.basePrefix }}/{cluster}/api-table/apiextensions.k8s.io/v1/customresourcedefinitions
    {{ end }}
    {{ with .extraItems }}
      {{ . | toYaml | nindent 4 }}
    {{ end }}
  key: administration
  label: Administration
  {{ end }}
{{ end }}
{{ end }}
