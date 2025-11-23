{{- define "incloud-web-resources.factory.manifets.daemonset-details" -}}
{{- $key            := (default "daemonset-details" .key) -}}
{{- $resName        := (default "{6}" .resName) -}}
{{- $podFactoryName := (default "factory-/v1/pods" .podFactoryName) -}}
{{- $trivyEnabled   := (default false .trivyEnabled) -}}
{{- $basePrefix     := (default "openapi-ui" .basePrefix) -}}

---
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  # Unique key for this factory configuration
  key: "{{ $key }}"

  # Sidebar category tags
  sidebarTags:
    - daemonset-details

  # Enable scrollable content card for main section
  withScrollableMainContentCard: true

  # API endpoint for fetching DaemonSet details--
  urlsToFetch:
    - cluster: "{2}"
      apiGroup: "{6}"
      apiVersion: "{7}"
      namespace: "{3}"
      plural: "{8}"
      fieldSelector: "metadata.name={9}"

  data:
    # === HEADER ROW ===
    - type: antdFlex
      data:
        id: ds-header
        gap: 6
        align: center
        style:
          marginBottom: 24px
      children:
        # factory badge
        - type: ResourceBadge
          data:
            id: factory-resource-badge
            value: "{reqsJsonPath[0]['.items.0.kind']['-']}"
            style:
              fontSize: 20px

        # DaemonSet name
        - type: parsedText
          data:
            id: ds-header-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # === MAIN TABS ===
    - type: antdTabs
      data:
        id: ds-tabs
        defaultActiveKey: details
        items:
          # ------ DETAILS TAB ------
          - key: details
            label: Details
            children:
              # Main card container for details section
              - type: ContentCard
                data:
                  id: ds-details-card
                  style:
                    marginBottom: 24px
                children:
                  # Section title
                  - type: antdText
                    data:
                      id: ds-details-title
                      text: DaemonSet details
                      strong: true
                      style:
                        fontSize: 20px
                        marginBottom: 12px

                  # Spacer for visual separation
                  - type: Spacer
                    data:
                      id: ds-spacer
                      $space: 16

                  # Grid layout: left and right columns
                  - type: antdRow
                    data:
                      id: ds-main-row
                      gutter: [48, 12]
                    children:
                      # LEFT COLUMN: Metadata and selectors
                      - type: antdCol
                        data:
                          id: ds-left-col
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: ds-left-stack
                              vertical: true
                              gap: 24
                            children:
                              # Resource name block
                              - type: antdFlex
                                data:
                                  id: ds-name-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: ds-name-label
                                      text: Name
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: ds-name-value
                                      text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"

                              # Namespace link block
                              - type: antdFlex
                                data:
                                  id: meta-namespace-block
                                  vertical: true
                                  gap: 8
                                children:
                                  - type: antdText
                                    data:
                                      id: meta-name-label
                                      text: Namespace
                                      strong: true

                                  - type: antdFlex
                                    data:
                                      id: namespace-badge-link-row
                                      direction: row
                                      align: center
                                      gap: 6   # расстояние между иконкой и текстом
                                    children:
                                      - type: ResourceBadge
                                        data:
                                          id: namespace-resource-badge
                                          value: Namespace
                                      {{ include "incloud-web-resources.factory.linkblock" (dict
                                          "reqIndex" 0
                                          "type" "namespace"
                                          "jsonPath" ".items.0.metadata.namespace"
                                          "factory" "namespace-details/v1/namespaces"
                                          "basePrefix" $basePrefix
                                        ) | nindent 38
                                      }}
                              # Labels display block
                              - type: antdFlex
                                data:
                                  id: ds-labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/daemonsets/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=apps~v1~daemonsets&labels="
                                      "jsonPath" ".items.0.metadata.labels"
                                    ) | nindent 34
                                  }}

                              # Node selector block
                              - type: antdFlex
                                data:
                                  id: ds-node-selector
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: "node-selector"
                                      text: "Node selector"
                                      strong: true
                                      style:
                                        fontSize: 14
                                  {{ include "incloud-web-resources.factory.labels.base.selector" (dict
                                      "type" "node"
                                      "jsonPath" ".items.0.spec.template.spec.nodeSelector"
                                      "basePrefix" $basePrefix
                                      "linkPrefix" "/openapi-ui/{2}/{3}/search?kinds=~v1~nodes&labels="
                                    ) | nindent 34
                                  }}

                              # Pod selector block
                              - type: antdFlex
                                data:
                                  id: ds-pod-selector
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: "pod-selector"
                                      text: "Pod selector"
                                      strong: true
                                      style:
                                        fontSize: 14
                                  {{ include "incloud-web-resources.factory.labels.base.selector" (dict
                                      "type" "pod"
                                      "jsonPath" ".items.0.spec.template.metadata.labels"
                                      "basePrefix" $basePrefix
                                      "linkPrefix" "/openapi-ui/{2}/{3}/search?kinds=~v1~pods&&labels="
                                    ) | nindent 34
                                  }}

  
                              # Tolerations counter block
                              - type: antdFlex
                                data:
                                  id: ds-tolerations
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.tolerations.block" (dict 
                                    "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/daemonsets/{6}"
                                    "jsonPathToArray" ".items.0.spec.template.spec.tolerations"
                                    "pathToValue" "/spec/template/spec/tolerations"
                                    ) | nindent 34
                                  }}

                              # Annotations counter block
                              - type: antdFlex
                                data:
                                  id: ds-annotations
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.annotations.block" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/daemonsets/{6}"
                                      "jsonPath" ".items.0.metadata.annotations"
                                      "pathToValue" "/metadata/annotations"
                                    ) | nindent 34
                                  }}

                              # Creation time block
                              - type: antdFlex
                                data:
                                  id: ds-created-time
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".items.0.metadata.creationTimestamp"
                                    "text" "Created"
                                    ) | nindent 30
                                  }}

                      # RIGHT COLUMN: Status counts
                      - type: antdCol
                        data:
                          id: ds-right-col
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: ds-right-stack
                              vertical: true
                              gap: 24
                            children:
                              # Current pods count
                              - type: antdFlex
                                data:
                                  id: ds-current-count
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: ds-current-count-label
                                      text: Current count
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: ds-current-count-value
                                      text: "{reqsJsonPath[0]['.items.0.status.currentNumberScheduled']['-']}"

                              # Desired pods count
                              - type: antdFlex
                                data:
                                  id: ds-desired-count
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: ds-desired-count-label
                                      text: Desired count
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: ds-desired-count-value
                                      text: "{reqsJsonPath[0]['.items.0.status.desiredNumberScheduled']['-']}"

                  # ---- INIT CONTAINERS SECTION ----
                  - type: antdCol
                    data:
                      id: ds-init-containers-col
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      - type: VisibilityContainer
                        data:
                          id: ds-init-containers-container
                          value: "{reqsJsonPath[0]['.items.0.spec.template.spec.initContainers']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          - type: antdText
                            data:
                              id: init-containers-title
                              text: Init containers
                              strong: true
                              style:
                                fontSize: 22
                                marginBottom: 32px
                          - type: EnrichedTable
                            data:
                              id: containers-table
                              cluster: "{2}"
                              customizationId: "container-spec-containers-list"
                              baseprefix: "/openapi-ui"
                              withoutControls: true
                              pathToItems: .items.0.spec.template.spec.initContainers
                              k8sResourceToFetch: 
                                apiGroup: "apps"
                                apiVersion: "v1"
                                plural: "daemonsets"
                                namespace: "{3}"
                              fieldSelector: 
                                metadata.name: "{9}"

                  # ---- CONTAINERS SECTION ----
                  - type: antdCol
                    data:
                      id: ds-containers-col
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      - type: VisibilityContainer
                        data:
                          id: ds-containers-container
                          value: "{reqsJsonPath[0]['.items.0.spec.template.spec.containers']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          - type: antdText
                            data:
                              id: init-containers-title
                              text: Containers
                              strong: true
                              style:
                                fontSize: 22
                                marginBottom: 32px
                          - type: EnrichedTable
                            data:
                              id: containers-table
                              cluster: "{2}"
                              customizationId: "container-spec-containers-list"
                              baseprefix: "/openapi-ui"
                              withoutControls: true
                              pathToItems: .items.0.spec.template.spec.containers
                              k8sResourceToFetch: 
                                apiGroup: "apps"
                                apiVersion: "v1"
                                plural: "daemonsets"
                                namespace: "{3}"
                              fieldSelector: 
                                metadata.name: "{9}"

          # ------ YAML TAB ------
          - key: yaml
            label: YAML
            children:
              # In-place editor bound to the same Deployment
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  type: api
                  pathToData: .items.0
                  plural: daemonsets
                  forcedKind: DaemonSet
                  apiGroup: apps
                  apiVersion: v1

          # ------ PODS TAB ------
          - key: pods
            label: Pods
            children:
              # Table filtered by Deployment's Pod template labels
              - type: EnrichedTable
                data:
                  id: ds-pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods"
                  id: pods-table
                  baseprefix: /{{ $basePrefix }}
                  cluster: "{2}"
                  customizationId: "{{ $podFactoryName }}"
                  k8sResourceToFetch: 
                    version: "v1"
                    plural: "pods"
                    namespace: "{3}"
                  dataForControls:
                    resource: pods
                    apiVersion: v1
                  labelSelectorFull:
                    reqIndex: 0
                    pathToLabels:  '.items.0.spec.template.metadata.labels'
                  # Path to items list in the response
                  pathToItems: ".items"
                  withoutControls: false

          - key: events
            label: Events
            children:
              - type: Events
                data:
                  id: events
                  baseprefix: "/openapi-ui"
                  cluster: "{2}"
                  wsUrl: "/api/clusters/{2}/openapi-bff-ws/events/eventsWs"
                  pageSize: 50
                  substractHeight: 315
                  limit: 40
                  fieldSelector:
                    regarding.kind: "{reqsJsonPath[0]['.items.0.kind']['-']}"
                    regarding.name: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
                    regarding.namespace: "{reqsJsonPath[0]['.items.0.metadata.namespace']['-']}"
                    regarding.apiVersion: "{reqsJsonPath[0]['.items.0.apiVersion']['-']}"
                  baseFactoryNamespacedAPIKey: base-factory-namespaced-api
                  baseFactoryClusterSceopedAPIKey: base-factory-clusterscoped-api
                  baseFactoryNamespacedBuiltinKey: base-factory-namespaced-builtin
                  baseFactoryClusterSceopedBuiltinKey: base-factory-clusterscoped-builtin
                  baseNamespaceFactoryKey: namespace-details

  {{- if $trivyEnabled }}
          # ------ PODS TAB ------
          - key: reports
            label: Reports
            children:
              - type: EnrichedTable
                data:
                  id: ds-pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/aquasecurity.github.io/v1alpha1/namespaces/{3}/vulnerabilityreports"
                  cluster: "{2}"
                  customizationId: factory-aquasecurity.github.io.v1alpha1.vulnerabilityreports
                  baseprefix: "/{{ $basePrefix }}"
                  # Build label selector from pod template labels
                  labelSelector:
                    trivy-operator.resource.name: "{reqsJsonPath[0]['.items.0.metadata.name']}"
                    trivy-operator.container.name: "{reqsJsonPath[0]['.items.0.spec.template.spec.containers[0].name']}"
                  # Items path for Pods list
                  pathToItems: ".items[*].report.vulnerabilities"

          - key: config-reports
            label: Config reports
            children:
              - type: EnrichedTable
                data:
                  id: ds-pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/aquasecurity.github.io/v1alpha1/namespaces/{3}/configauditreports"
                  cluster: "{2}"
                  customizationId: factory-aquasecurity.github.io.v1alpha1.configauditreports
                  baseprefix: "/{{ $basePrefix }}"
                  # Build label selector from pod template labels
                  labelSelector:
                    trivy-operator.resource.name: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
                    trivy-operator.resource.kind: "{reqsJsonPath[0]['.items.0.kind']['-']}"
                  # Items path for Pods list
                  pathToItems: ".items[*].report.checks"

  {{- end -}}
{{- end -}}
