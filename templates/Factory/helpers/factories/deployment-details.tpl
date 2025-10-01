{{- define "incloud-web-resources.factory.manifets.deployment-details" -}}
{{- $key            := (default "deployment-details" .key) -}}
{{- $resName        := (default "{6}" .resName) -}}
{{- $rsFactoryName  := (default "factory-/v1/pods" .rsFactoryName) -}}
{{- $podFactoryName := (default "factory-/v1/pods" .podFactoryName) -}}
{{- $basePrefix     := (default "openapi-ui" .basePrefix) -}}

---
# Factory definition for Deployment details page
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  # Stable key used by the UI router/registry
  key: "{{ $key }}"

  # Sidebar categorization
  sidebarTags:
    - deployment-sidebar

  # API request used to fetch the target Deployment
  urlsToFetch:
    - /api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/deployments/{{ $resName }}

  # Enables scrollable main content area
  withScrollableMainContentCard: true

  # Root component tree
  data:
    # === Header with icon, name and high-level status ===
    - type: antdFlex
      data:
        id: header-flex
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

        # Center: deployment name from the fetched object
        - type: parsedText
          data:
            id: header-name
            text: "{reqsJsonPath[0]['.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

        - type: antdFlex
          data:
            id: status-header-block
            vertical: true
            gap: 4
          children:
            {{ include "incloud-web-resources.factory.statuses.deployment" . | nindent 12 }}

    # === Main content organized by tabs ===
    - type: antdTabs
      data:
        id: deployment-tabs
        defaultActiveKey: details
        items:
          # ------ DETAILS TAB ------
          - key: details
            label: Details
            children:
              # Card wrapper for details content
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  # Section title
                  - type: antdText
                    data:
                      id: details-title
                      text: Deployment details
                      strong: true
                      style:
                        fontSize: 20
                        marginBottom: 12px

                  # Spacer for breathing room
                  - type: Spacer
                    data:
                      id: details-spacer
                      "$space": 16

                  # Two-column layout for metadata and rollout settings
                  - type: antdRow
                    data:
                      id: main-details-row
                      gutter: [48, 12]
                    children:
                      # === LEFT COLUMN: Metadata & links ===
                      - type: antdCol
                        data:
                          id: left-column
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: left-column-flex
                              vertical: true
                              gap: 24
                            children:
                              # Name block
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

                              # Namespace link block (rendered by include)
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
                                      gap: 6
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

                              # Labels list (rendered by include)
                              - type: antdFlex
                                data:
                                  id: labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/deployments/{{ $resName }}"
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
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~nodes&labels="
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
                                      "jsonPath" ".spec.template.metadata.labels"
                                      "basePrefix" $basePrefix
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~pods&labels="
                                    ) | nindent 34
                                  }}


                              # Tolerations counter (rendered by include)
                              - type: antdFlex
                                data:
                                  id: tolerations-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.tolerations.block" (dict 
                                    "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/deployments/{{ $resName }}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/deployments/{{ $resName }}"
                                    ) | nindent 34
                                  }}

                              # Created timestamp (rendered by include)
                              - type: antdFlex
                                data:
                                  id: created-time-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".metadata.creationTimestamp"
                                    "text" "Created"
                                  ) | nindent 38 
                                  }}

                              # Owner reference (fallback text if no owner)
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
                              #         strong: true
                              #         text: "No owner"
                              #         style:
                              #           color: red

                      # === RIGHT COLUMN: Rollout and timing settings ===
                      - type: antdCol
                        data:
                          id: right-column
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: right-column-flex
                              vertical: true
                              gap: 24
                            children:
                              # Status block (mirrors header status)
                              - type: antdFlex
                                data:
                                  id: status-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: status-label
                                      text: Status
                                      strong: true
                                  - type: antdFlex
                                    data:
                                      id: status-header-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      {{ include "incloud-web-resources.factory.statuses.deployment" . | nindent 38 }}

                              # Rolling update strategy type
                              - type: antdFlex
                                data:
                                  id: update-strategy-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: update-strategy-label
                                      text: Update strategy
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: update-strategy-value
                                      text: "{reqsJsonPath[0]['.spec.strategy.type']['-']}"

                              # MaxUnavailable value
                              - type: antdFlex
                                data:
                                  id: max-unavailable-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: max-unavailable-label
                                      text: Max unavailable
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: max-unavailable-value
                                      text: "{reqsJsonPath[0]['.spec.strategy.rollingUpdate.maxUnavailable']['-']}"

                              # MaxSurge value
                              - type: antdFlex
                                data:
                                  id: max-surge-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: max-surge-label
                                      text: Max surge
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: max-surge-value
                                      text: "{reqsJsonPath[0]['.spec.strategy.rollingUpdate.maxSurge']['-']}"

                              # ProgressDeadlineSeconds
                              - type: antdFlex
                                data:
                                  id: progress-deadline-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: progress-deadline-label
                                      text: Progress deadline seconds
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: progress-deadline-value
                                      text: "{reqsJsonPath[0]['.spec.progressDeadlineSeconds']['-']}"

                              # MinReadySeconds
                              - type: antdFlex
                                data:
                                  id: min-ready-seconds-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: min-ready-seconds-label
                                      text: Min ready seconds
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: min-ready-seconds-value
                                      text: "{reqsJsonPath[0]['.spec.minReadySeconds']['-']}"

                  # === Volumes table (visible only if volumes exist) ===
                  # TODO to be done
                  # - type: antdCol
                  #   data:
                  #     id: volumes-column
                  #     style:
                  #       marginTop: 16
                  #       padding: 10
                  #   children:
                  #     - type: VisibilityContainer
                  #       data:
                  #         id: volumes-container
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
                  #               marginBottom: 16px
                  #         - type: EnrichedTable
                  #           data:
                  #             id: volumes-table
                  #             fetchUrl: /api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/deployments/{{ $resName }}
                  #             clusterNamePartOfUrl: "{2}"
                  #             customizationId: factory-deployment-details-volume-list
                  #             baseprefix: /{{ $basePrefix }}
                  #             withoutControls: true
                  #             # Path in the fetched object to the volumes array
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
                              "kind" "deployments"
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
                              "kind" "deployments"
                              "resourceName" $resName
                              "namespace" "{3}"
                              "jsonPath" ".spec.template.spec.containers"
                              "pathToItems" "['spec','template','spec','containers']"
                              "basePrefix" $basePrefix
                            ) | nindent 26
                          }}

                  # === Conditions table (visible only if status.conditions exist) ===
                  - type: antdCol
                    data:
                      id: conditions-column
                      style:
                        marginTop: 16
                        padding: 10
                    children:
                      - type: VisibilityContainer
                        data:
                          id: conditions-container
                          value: "{reqsJsonPath[0]['.status.conditions']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          - type: antdText
                            data:
                              id: conditions-title
                              text: Conditions
                              strong: true
                              style:
                                fontSize: 22px
                                marginBottom: 16px
                          - type: EnrichedTable
                            data:
                              id: conditions-table
                              fetchUrl: /api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/deployments/{{ $resName }}
                              clusterNamePartOfUrl: "{2}"
                              customizationId: factory-status-conditions
                              baseprefix: /{{ $basePrefix }}
                              withoutControls: true
                              # Path in the fetched object to the conditions array
                              pathToItems: ".status.conditions"

          # ------ YAML TAB ------
          - key: yaml
            label: YAML
            children:
              # In-place editor bound to the same Deployment
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  apiGroup: apps
                  apiVersion: v1
                  cluster: "{2}"
                  isNameSpaced: true
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  type: apis
                  typeName: deployments

          # ------ REPLICASETS TAB ------
          - key: replicasets
            label: ReplicaSets
            children:
              # Table filtered by Deployment's Pod template labels
              - type: EnrichedTable
                data:
                  id: replicasets-table
                  fetchUrl: /api/clusters/{2}/k8s/apis/apps/v1/namespaces/{3}/replicasets
                  baseprefix: /{{ $basePrefix }}
                  clusterNamePartOfUrl: "{2}"
                  customizationId: "{{ $rsFactoryName }}"
                  labelsSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".spec.template.metadata.labels"
                  # Path to items list in the response
                  pathToItems: ".items"
                  withoutControls: true

          # ------ PODS TAB ------
          - key: pods
            label: Pods
            children:
              # Table filtered by Deployment's Pod template labels
              - type: EnrichedTable
                data:
                  id: pods-table
                  fetchUrl: /api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods
                  baseprefix: /{{ $basePrefix }}
                  clusterNamePartOfUrl: "{2}"
                  customizationId: "{{ $podFactoryName }}"
                  labelsSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".spec.template.metadata.labels"
                  # Path to items list in the response
                  pathToItems: ".items"
                  withoutControls: true
{{- end -}}
