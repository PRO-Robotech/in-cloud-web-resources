{{- define "incloud-web-resources.factory.manifets.replicationcontroller-details" -}}
{{- $key            := (default "replicationcontroller-details" .key) -}}
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
    - replicationcontroller-details
  withScrollableMainContentCard: true
  urlsToFetch:
    - cluster: "{2}"
      apiVersion: "{6}"
      namespace: "{3}"
      plural: "{7}"
      fieldSelector: "metadata.name={8}"

  # Header row with badge and ReplicationController name
  data:
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

        # ReplicationController name
        - type: parsedText
          data:
            id: rc-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # Tabs with Details, YAML, and Pods
    - type: antdTabs
      data:
        id: rc-tabs
        defaultActiveKey: details
        items:
          # Details tab with metadata and spec info
          - key: details
            label: Details
            children:
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  # Title
                  - type: antdText
                    data:
                      id: details-title
                      text: ReplicationController details
                      strong: true
                      style:
                        fontSize: 20px
                        marginBottom: 12px

                  # Spacer
                  - type: Spacer
                    data:
                      id: details-spacer
                      $space: 16

                  # Two-column layout
                  - type: antdRow
                    data:
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      # Left column: metadata
                      - type: antdCol
                        data:
                          id: col-left
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: col-left-stack
                              vertical: true
                              gap: 24
                            children:
                              # Name block
                              - type: antdFlex
                                data:
                                  id: meta-name-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: meta-name-label
                                      text: Name
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: meta-name-value
                                      text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"

                              # Namespace link
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

                              # Labels
                              - type: antdFlex
                                data:
                                  id: meta-labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/replicationcontrollers/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~replicationcontrollers&labels="
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
                                      "linkPrefix" "/openapi-ui/{2}/{3}/search?kinds=~v1~pods&labels="
                                    ) | nindent 34
                                  }}

                              # Tolerations
                              - type: antdFlex
                                data:
                                  id: meta-tolerations-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.tolerations.block" (dict 
                                    "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/replicationcontrollers/{6}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/replicationcontrollers/{6}"
                                      "jsonPath" ".items.0.metadata.annotations"
                                      "pathToValue" "/metadata/annotations"
                                    ) | nindent 34
                                  }}

                              # Created timestamp
                              - type: antdFlex
                                data:
                                  id: meta-created-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".items.0.metadata.creationTimestamp"
                                    "text" "Created"
                                  ) | nindent 38}}

                              # Owner block
                              # - type: antdFlex
                              #   data:
                              #     id: meta-owner-block
                              #     vertical: true
                              #     gap: 4
                              #   children:
                              #     - type: antdText
                              #       data:
                              #         id: meta-owner-label
                              #         text: Owner
                              #         strong: true
                              #     - type: parsedText
                              #       data:
                              #         id: meta-owner-fallback
                              #         strong: true
                              #         text: "No owner"
                              #         style:
                              #           color: red

                      # Right column: replica counts
                      - type: antdCol
                        data:
                          id: col-right
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: col-right-stack
                              vertical: true
                              gap: 24
                            children:
                              # Current replicas
                              - type: antdFlex
                                data:
                                  id: replicas-current-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: replicas-current-label
                                      text: Current count
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: replicas-current-value
                                      text: "{reqsJsonPath[0]['.items.0.status.replicas']['-']}"

                              # Desired replicas
                              - type: antdFlex
                                data:
                                  id: replicas-desired-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: replicas-desired-label
                                      text: Desired count
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: replicas-desired-value
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
                              baseprefix: "/{{ $basePrefix }}"
                              withoutControls: true
                              pathToItems: .items.0.spec.template.spec.initContainers
                              k8sResourceToFetch: 
                                apiGroup: "apps"
                                apiVersion: "v1"
                                plural: "replicasets"
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
                              baseprefix: "/{{ $basePrefix }}"
                              withoutControls: true
                              pathToItems: .items.0.spec.template.spec.containers
                              k8sResourceToFetch: 
                                apiGroup: "apps"
                                apiVersion: "v1"
                                plural: "replicasets"
                                namespace: "{3}"
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
                  type: api
                  plural: replicationcontrollers
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  pathToData: .items.0
                  forcedKind: Replicationcontroller
                  apiVersion: v1

          # Pods tab
          - key: pods
            label: Pods
            children:
              # Table filtered by Deployment's Pod template labels
              - type: EnrichedTable
                data:
                  id: pods-table
                  baseprefix: /{{ $basePrefix }}
                  cluster: "{2}"
                  customizationId: "{{ $podFactoryName }}"
                  k8sResourceToFetch: 
                    apiVersion: "v1"
                    plural: "pods"
                    namespace: "{3}"
                  dataForControls:
                    plural: pods
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
                  baseprefix: "/{{ $basePrefix }}"
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

{{- end -}}
