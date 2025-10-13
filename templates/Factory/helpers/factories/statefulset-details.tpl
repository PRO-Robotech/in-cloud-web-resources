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
    - statefulset-sidebar
  withScrollableMainContentCard: true
  urlsToFetch:
    - "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/statefulsets/{{ $resName }}"

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
            value: "{reqsJsonPath[0]['.kind']['-']}"
            style:
              fontSize: 20px

        # StatefulSet name
        - type: parsedText
          data:
            id: header-name
            text: "{reqsJsonPath[0]['.metadata.name']['-']}"
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
                                      text: "{reqsJsonPath[0]['.metadata.name']['-']}"

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
                                          "jsonPath" ".metadata.namespace"
                                          "factory" "namespace-details"
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/statefulsets/{{ $resName }}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=apps~v1~statefulsets&labels="
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
                                      "jsonPath" ".spec.template.spec.nodeSelector"
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
                                      "jsonPath" ".spec.template.metadata.labels"
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
                                    "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/statefulsets/{{ $resName }}"
                                    "jsonPathToArray" ".spec.template.spec.tolerations"
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/statefulsets/{{ $resName }}"
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
                                    "req" ".metadata.creationTimestamp"
                                    "text" "Created"
                                    ) | nindent 34
                                  }}

                              # Owner (fallback when missing)
                              # - type: antdFlex
                              #   data:
                              #     id: owner-block
                              #     vertical: true
                              #     gap: 4
                              #   children:
                              #     - type: antdText
                              #       data:
                              #         id: owner-label
                              #         text: Owner
                              #         strong: true
                              #     - type: parsedText
                              #       data:
                              #         id: owner-value
                              #         text: "No owner"
                              #         style:
                              #           color: red

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
                                      text: "{reqsJsonPath[0]['.status.replicas']['-']}"
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
                                      text: "{reqsJsonPath[0]['.spec.replicas']['-']}"

                  # Volumes section
                  # TODO to be done
                  # - type: antdCol
                  #   data:
                  #     id: volumes-section-col
                  #     style:
                  #       marginTop: 10
                  #       padding: 10
                  #   children:
                  #     - type: VisibilityContainer
                  #       data:
                  #         id: volumes-visibility
                  #         value: "{reqsJsonPath[0]['.spec.template.spec.volumes']['-']}"
                  #         style:
                  #           margin: 0
                  #           padding: 0
                  #       children:
                  #         - type: antdText
                  #           data:
                  #             id: volumes-title
                  #             text: Volumes
                  #             strong: true
                  #             style:
                  #               fontSize: 22px
                  #               marginBottom: 32px
                  #         - type: EnrichedTable
                  #           data:
                  #             id: volumes-table
                  #             fetchUrl: "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/statefulsets/{{ $resName }}"
                  #             clusterNamePartOfUrl: "{2}"
                  #             customizationId: factory-statefulset-details-volume-list
                  #             baseprefix: "{{ $basePrefix }}"
                  #             pathToItems: ".spec.template.spec.volumes"


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
                          value: "{reqsJsonPath[0]['.spec.template.spec.initContainers']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          {{ include "incloud-web-resources.factory.containers.table" (dict
                              "title" "Init containers"
                              "customizationId" "container-spec-init-containers-list"
                              "type" "init-containers"
                              "apiGroup" "apis/apps/v1"
                              "kind" "statefulsets"
                              "resourceName" $resName
                              "namespace" "{3}"
                              "jsonPath" ".spec.template.spec.initContainers"
                              "pathToItems" "['spec','template','spec','initContainers']"
                              "basePrefix" $basePrefix
                            ) | nindent 26
                          }}

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
                          value: "{reqsJsonPath[0]['.spec.template.spec.containers']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          {{ include "incloud-web-resources.factory.containers.table" (dict
                              "title" "Containers"
                              "customizationId" "container-spec-containers-list"
                              "type" "containers"
                              "apiGroup" "apis/apps/v1"
                              "kind" "statefulsets"
                              "resourceName" $resName
                              "namespace" "{3}"
                              "jsonPath" ".spec.template.spec.containers"
                              "pathToItems" "['spec','template','spec','containers']"
                              "basePrefix" $basePrefix
                            ) | nindent 26
                          }}

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
                  apiGroup: apps
                  apiVersion: v1
                  typeName: statefulsets
                  prefillValuesRequestIndex: 0
                  substractHeight: 400

          # Pods tab
          - key: pods
            label: Pods
            children:
              - type: EnrichedTable
                data:
                  id: pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: "{{ $podFactoryName }}"
                  labelsSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".spec.template.metadata.labels"
                  pathToItems: ".items"

  {{- if $trivyEnabled }}
          # ------ PODS TAB ------
          - key: reports
            label: Reports
            children:
              - type: EnrichedTable
                data:
                  id: ds-pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/aquasecurity.github.io/v1alpha1/clusterinfraassessmentreports"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: factory-aquasecurity.github.io.v1alpha1.clusterinfraassessmentreports
                  baseprefix: "/{{ $basePrefix }}"
                  # Build label selector from pod template labels
                  labelsSelector:
                    trivy-operator.resource.name: "{reqsJsonPath[0]['.metadata.name']['-']}"
                    trivy-operator.resource.kind: "{reqsJsonPath[0]['.kind']['-']}"
                  # Items path for Pods list
                  pathToItems: ".items[*].report.checks"
                  namespace: "{3}"
                  isNamespaced: false
                  dataForControls:
                    resource: clusterinfraassessmentreports
                    apiVersion: v1alpha1
                    apiGroup: aquasecurity.github.io

  {{- end -}}
{{- end -}}
