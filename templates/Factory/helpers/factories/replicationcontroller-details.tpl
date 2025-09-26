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
    - replicationcontroller-sidebar
  withScrollableMainContentCard: true
  urlsToFetch:
    - "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/replicationcontrollers/{{ $resName }}"

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
        # ReplicationController badge
        - type: antdText
          data:
            id: badge-rc
            text: RC
            title: replicationcontroller
            style:
              fontSize: 20px
              lineHeight: 24px
              padding: "0 9px"
              borderRadius: "20px"
              minWidth: 24
              display: inline-block
              textAlign: center
              whiteSpace: nowrap
              color: "#fff"
              backgroundColor: "#004080"
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif
              fontWeight: 400
        # ReplicationController name
        - type: parsedText
          data:
            id: rc-name
            text: "{reqsJsonPath[0]['.metadata.name']['-']}"
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
                                      text: "{reqsJsonPath[0]['.metadata.name']['-']}"

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

                                  {{ include "incloud-web-resources.icon" (dict
                                      "text" "NS"
                                      "title" "namespace"
                                      "backgroundColor" "#a25792ff"
                                    )| nindent 34
                                  }}
                                  {{ include "incloud-web-resources.factory.linkblock" (dict
                                      "reqIndex" 0
                                      "type" "namespace"
                                      "jsonPath" ".metadata.namespace"
                                      "factory" "namespace-details"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/replicationcontrollers/{{ $resName }}"
                                    ) | nindent 34
                                  }}

                              # Node selector
                              - type: antdFlex
                                data:
                                  id: meta-node-selector-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.labels.base.selector" (dict
                                      "type" "node"
                                      "title" "Node selector"
                                      "jsonPath" ".spec.template.spec.nodeSelector"
                                      "basePrefix" $basePrefix
                                    ) | nindent 34
                                  }}

                              # Pod selector
                              - type: antdFlex
                                data:
                                  id: meta-pod-selector-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.labels.base.selector" (dict
                                      "type" "pod"
                                      "title" "Pod selector"
                                      "jsonPath" ".spec.template.metadata.labels"
                                      "basePrefix" $basePrefix
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
                                    "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/replicationcontrollers/{{ $resName }}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/replicationcontrollers/{{ $resName }}"
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
                                    "req" ".metadata.creationTimestamp"
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
                                      text: "{reqsJsonPath[0]['.status.replicas']['-']}"

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
                                      text: "{reqsJsonPath[0]['.spec.replicas']['-']}"

                  # Volumes section
                  # TODO to be done
                  # - type: antdCol
                  #   data:
                  #     id: volumes-col
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
                  #             fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/replicationcontrollers/{{ $resName }}"
                  #             clusterNamePartOfUrl: "{2}"
                  #             customizationId: factory-replicationcontroller-details-volume-list
                  #             baseprefix: "/{{ $basePrefix }}"
                  #             withoutControls: true
                  #             pathToItems:
                  #               - spec
                  #               - template
                  #               - spec
                  #               - volumes

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
                              "kind" "replicationcontrollers"
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
                              "apiGroup" "api/v1"
                              "kind" "replicationcontrollers"
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
                  type: builtin
                  typeName: replicationcontrollers
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
                  baseprefix: "/{{ $basePrefix }}"
                  withoutControls: true
                  labelsSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".spec.template.metadata.labels"
                  pathToItems: ".items"
{{- end -}}
