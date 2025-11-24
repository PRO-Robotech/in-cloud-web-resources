{{- define "incloud-web-resources.factory.manifets.statefulset-details" -}}
{{- $key            := (default "statefulset-details" .key) -}}
{{- $trivyEnabled   := (default false .trivyEnabled) -}}
{{- $resName        := (default "{6}" .resName) -}}
{{- $podFactoryName := (default "factory-/v1/pods" .podFactoryName) -}}
{{- $basePrefix     := (default "openapi-ui" .basePrefix) -}}

---
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  key: "{{ $key }}"

  sidebarTags:
    - statefulset-details
  withScrollableMainContentCard: true
  urlsToFetch:
    - cluster: "{2}"
      apiGroup: "{6}"
      apiVersion: "{7}"
      namespace: "{3}"
      plural: "{8}"
      fieldSelector: "metadata.name={9}"

  data:
    # Header section
    - type: antdFlex
      data:
        id: header-row
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

        # StatefulSet name
        - type: parsedText
          data:
            id: header-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # Tabs section
    - type: antdTabs
      data:
        id: main-tabs
        defaultActiveKey: details
        items:
          # Details tab
          - key: details
            label: Details
            children:
              # Main info card
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  # Card title
                  - type: antdText
                    data:
                      id: details-title
                      text: StatefulSet details
                      strong: true
                      style:
                        fontSize: 20px
                        marginBottom: 12px

                  # Space under title
                  - type: Spacer
                    data:
                      id: details-spacer
                      $space: 16

                  # Two-column grid
                  - type: antdRow
                    data:
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      # Left column
                      - type: antdCol
                        data:
                          id: left-col
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: left-col-stack
                              vertical: true
                              gap: 24
                            children:
                              # Name
                              - type: antdFlex
                                data:
                                  id: name-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: name-label
                                      text: Name
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: name-value
                                      text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"

                              # Namespace link block (include)
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

                              # Labels block (include)
                              - type: antdFlex
                                data:
                                  id: labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/statefulsets/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=apps~v1~statefulsets&labels="
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
                                      id: "node-selector"
                                      text: "Node selector"
                                      strong: true
                                      style:
                                        fontSize: 14
                                  {{ include "incloud-web-resources.factory.labels.base.selector" (dict
                                      "type" "pod"
                                      "jsonPath" ".items.0.spec.template.metadata.labels"
                                      "basePrefix" $basePrefix
                                      "linkPrefix" "/openapi-ui/{2}/{3}/search?kinds=~v1~pods&labels="
                                    ) | nindent 34
                                  }}

                              # Tolerations counter (include)
                              - type: antdFlex
                                data:
                                  id: tolerations-counter-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.tolerations.block" (dict 
                                    "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/statefulsets/{6}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/statefulsets/{6}"
                                      "jsonPath" ".items.0.metadata.annotations"
                                      "pathToValue" "/metadata/annotations"
                                    ) | nindent 34
                                  }}

                              # Created time (include)
                              - type: antdFlex
                                data:
                                  id: created-time-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".items.0.metadata.creationTimestamp"
                                    "text" "Created"
                                    ) | nindent 34
                                  }}

                      # Right column
                      - type: antdCol
                        data:
                          id: right-col
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: right-col-stack
                              vertical: true
                              gap: 24
                            children:
                              # Current replicas
                              - type: antdFlex
                                data:
                                  id: current-count-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: current-count-label
                                      text: Current count
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: current-count-value
                                      text: "{reqsJsonPath[0]['.items.0.status.replicas']['-']}"

                              # Desired replicas
                              - type: antdFlex
                                data:
                                  id: desired-count-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: desired-count-label
                                      text: Desired count
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: desired-count-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.replicas']['-']}"

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
                                apiGroup: "{6}"
                                apiVersion: "{7}"
                                namespace: "{3}"
                                plural: "{8}"
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
                                apiGroup: "{6}"
                                apiVersion: "{7}"
                                namespace: "{3}"
                                plural: "{8}"
                              fieldSelector: 
                                metadata.name: "{9}"

          # YAML tab
          - key: yaml
            label: YAML
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: apis
                  plural: statefulsets
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  pathToData: .items.0
                  forcedKind: StatefulSet
                  apiGroup: apps
                  apiVersion: v1

          # Pods tab
          - key: pods
            label: Pods
            children:
              - type: EnrichedTable
                data:
                  id: pods-table
                  cluster: "{2}"
                  customizationId: "{{ $podFactoryName }}"
                  labelSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".items.0.spec.template.metadata.labels"
                  pathToItems: ".items"
                  k8sResourceToFetch: 
                    apiVersion: "v1"
                    plural: "pods"
                    namespace: "{3}"
                  dataForControls:
                    cluster: "{2}"
                    apiVersion: "v1"
                    plural: "pods"
                    namespace: "{3}"

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
                    regarding.kind: "StatefulSet"
                    regarding.name: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
                    regarding.namespace: "{reqsJsonPath[0]['.items.0.metadata.namespace']['-']}"
                    regarding.apiVersion: "apps/v1"
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
                  fetchUrl: "/api/clusters/{2}/k8s/apis/aquasecurity.github.io/v1alpha1/clusterinfraassessmentreports"
                  cluster: "{2}"
                  customizationId: factory-aquasecurity.github.io.v1alpha1.clusterinfraassessmentreports
                  baseprefix: "/{{ $basePrefix }}"
                  # Build label selector from pod template labels
                  labelSelector:
                    trivy-operator.resource.name: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
                    trivy-operator.resource.kind: "StatefulSet"
                  # Items path for Pods list
                  pathToItems: ".items[*].report.checks"
                  k8sResourceToFetch: 
                    apiVersion: "v1alpha1"
                    apiGroup: "aquasecurity.github.io"
                    plural: "clusterinfraassessmentreports"

  {{- end -}}
{{- end -}}
