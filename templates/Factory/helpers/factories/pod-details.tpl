{{- define "incloud-web-resources.factory.manifets.pod-details" -}}
{{- $key          := (default "pod-details" .key) -}}
{{- $resName      := (default "{6}" .resName) -}}
{{- $trivyEnabled := (default false .trivyEnabled) -}}
{{- $basePrefix   := (default "openapi-ui" .basePrefix) -}}

---
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  key: "{{ $key }}"
  sidebarTags:
    - pods-sidebar
  withScrollableMainContentCard: true
  urlsToFetch:
    - "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{{ $resName }}"

  # Header row with badge, pod name, and status
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
            value: "{reqsJsonPath[0]['.kind']['-']}"
            style:
              fontSize: 20px
        # Pod name next to badge
        - type: parsedText
          data:
            id: header-pod-name
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
            {{ include "incloud-web-resources.factory.statuses.pod" . | nindent 38 }}

    # Tabs with Details, YAML, Logs, and Terminal views
    - type: antdTabs
      data:
        id: pod-tabs
        defaultActiveKey: "details"
        items:
          # Details tab with metadata and spec
          - key: "details"
            label: "Details"
            children:
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  # Title of the details section
                  - type: antdText
                    data:
                      id: details-title
                      text: "Pod details"
                      strong: true
                      style:
                        fontSize: 20
                        marginBottom: 12px
                  # Spacer before grid
                  - type: Spacer
                    data:
                      id: details-spacer
                      "$space": 16
                  # Two-column layout for metadata (left) and status/spec (right)

                  - type: antdRow
                    data:
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      # Left column: metadata, links, labels
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
                              # Display name label/value
                              - type: antdFlex
                                data:
                                  id: meta-name-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: meta-name-label
                                      strong: true
                                      text: "Name"
                                  - type: parsedText
                                    data:
                                      id: meta-name-value
                                      text: "{reqsJsonPath[0]['.metadata.name']['-']}"

                              # Namespace link (kept as include)
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
                              # Labels list (kept as include)
                              - type: antdFlex
                                data:
                                  id: meta-labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                  {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{{ $resName }}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~pods&labels="
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

                              # Tolerations counter (kept as include)
                              - type: antdFlex
                                data:
                                  id: meta-tolerations-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.tolerations.block" (dict 
                                    "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{{ $resName }}"
                                    "jsonPathToArray" ".spec.tolerations"
                                    "pathToValue" "/spec/tolerations"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{{ $resName }}"
                                    ) | nindent 34
                                  }}

                              # Created timestamp (kept as include)
                              - type: antdFlex
                                data:
                                  id: meta-created-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".metadata.creationTimestamp"
                                    "text" "Created"
                                  ) | nindent 38
                                  }}

                              # Owner information (fallback when absent)
                              # - type: antdFlex
                              #   data:
                              #     id: meta-owner-block
                              #     vertical: true
                              #     gap: 4
                              #   children:
                              #     - type: antdText
                              #       data:
                              #         id: meta-owner-label
                              #         strong: true
                              #         text: "Owner"
                              #     - type: parsedText
                              #       data:
                              #         id: meta-owner-fallback
                              #         strong: true
                              #         text: "No owner"
                              #         style:
                              #           color: red

                      # Right column: status and runtime info
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
                              # Status block with readiness reason mapping
                              - type: antdFlex
                                data:
                                  id: status-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: status-label
                                      strong: true
                                      text: "Status"
                                  # Pod readiness/status indicator
                                  - type: antdFlex
                                    data:
                                      id: status-label-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      {{ include "incloud-web-resources.factory.statuses.pod" . | nindent 38 }}

                              # Restart policy
                              - type: antdFlex
                                data:
                                  id: restart-policy-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: restart-policy-label
                                      strong: true
                                      text: "Restart policy"
                                  - type: parsedText
                                    data:
                                      id: restart-policy-value
                                      text: "{reqsJsonPath[0]['.spec.restartPolicy']['-']} restart"

                              # Active deadline seconds
                              - type: antdFlex
                                data:
                                  id: active-deadline-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: active-deadline-label
                                      strong: true
                                      text: "Active deadline seconds"
                                  - type: parsedText
                                    data:
                                      id: active-deadline-value
                                      text: "{reqsJsonPath[0]['.spec.activeDeadlineSeconds']['-']}"

                              # Pod IP
                              - type: antdFlex
                                data:
                                  id: pod-ip-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: pod-ip-label
                                      strong: true
                                      text: "Pod IP"
                                  - type: parsedText
                                    data:
                                      id: pod-ip-value
                                      text: "{reqsJsonPath[0]['.status.podIP']['-']}"

                              # Host IP
                              - type: antdFlex
                                data:
                                  id: host-ip-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: host-ip-label
                                      strong: true
                                      text: "Host IP"
                                  - type: parsedText
                                    data:
                                      id: host-ip-value
                                      text: "{reqsJsonPath[0]['.status.hostIP']['-']}"

                              # Node details link (kept as include)
                              - type: antdFlex
                                data:
                                  id: node-link-block
                                  vertical: true
                                  gap: 8
                                children:
                                  - type: antdText
                                    data:
                                      id: meta-node
                                      text: Node
                                      strong: true
                                  - type: antdFlex
                                    data:
                                      id: node-badge-link-row
                                      direction: row
                                      align: center
                                      gap: 6   # расстояние между иконкой и текстом
                                    children:
                                      - type: ResourceBadge
                                        data:
                                          id: node-resource-badge
                                          value: Node
                                      {{ include "incloud-web-resources.factory.linkblock" (dict
                                          "reqIndex" 0
                                          "type" "name"
                                          "jsonPath" ".spec.nodeName"
                                          "factory" "node-details"
                                          "basePrefix" $basePrefix
                                        ) | nindent 38
                                      }}

                              # QoS class
                              - type: antdFlex
                                data:
                                  id: qos-class-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: qos-class-label
                                      strong: true
                                      text: "QOS class"
                                  - type: parsedText
                                    data:
                                      id: qos-class-value
                                      text: "{reqsJsonPath[0]['.status.qosClass']['-']}"

                  # Volumes section (table is hidden if no volumes)
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
                  #         value: "{reqsJsonPath[0]['.spec.volumes']['-']}"
                  #         style:
                  #           margin: 0
                  #           padding: 0
                  #       children:
                  #         # Volumes title
                  #         - type: antdText
                  #           data:
                  #             id: volumes-title
                  #             text: "Volumes"
                  #             strong: true
                  #             style:
                  #               fontSize: 22
                  #               marginBottom: 32px
                  #         # Volumes table
                  #         - type: EnrichedTable
                  #           data:
                  #             id: volumes-table
                  #             fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{{ $resName }}"
                  #             clusterNamePartOfUrl: "{2}"
                  #             customizationId: factory-pod-details-volume-list
                  #             baseprefix: "/{{ $basePrefix }}"
                  #             withoutControls: true
                  #             pathToItems: ".spec.volumes"


                  # Init containers section (hidden if none)
                  - type: antdCol
                    data:
                      id: init-containers-col
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      {{ include "incloud-web-resources.factory.containers.table" (dict
                          "title" "Init containers"
                          "customizationId" "container-status-init-containers-list"
                          "type" "init-containers"
                          "apiGroup" "api/v1"
                          "kind" "pods"
                          "resourceName" $resName
                          "namespace" "{3}"
                          "jsonPath" ".status.initContainerStatuses"
                          "pathToItems" "['status','initContainerStatuses']"
                          "basePrefix" $basePrefix
                        ) | nindent 22 
                      }}

                  # Containers section (hidden if none)
                  - type: antdCol
                    data:
                      id: containers-col
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      {{ include "incloud-web-resources.factory.containers.table" (dict
                          "title" "Containers"
                          "customizationId" "container-status-containers-list"
                          "type" "containers"
                          "apiGroup" "api/v1"
                          "kind" "pods"
                          "resourceName" $resName
                          "namespace" "{3}"
                          "jsonPath" ".status.containerStatuses"
                          "pathToItems" "['status','containerStatuses']"
                          "basePrefix" $basePrefix
                        ) | nindent 22 
                      }}

                  # Conditions section (hidden if none)
                  - type: antdCol
                    data:
                      id: conditions-col
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      - type: VisibilityContainer
                        data:
                          id: conditions-visibility
                          value: "{reqsJsonPath[0]['.status.conditions']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          # Conditions title
                          - type: antdText
                            data:
                              id: conditions-title
                              text: "Conditions"
                              strong: true
                              style:
                                fontSize: 22
                          # Conditions table
                          - type: EnrichedTable
                            data:
                              id: conditions-table
                              fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{{ $resName }}"
                              clusterNamePartOfUrl: "{2}"
                              customizationId: factory-status-conditions
                              baseprefix: "/{{ $basePrefix }}"
                              withoutControls: true
                              pathToItems: ".status.conditions"

          # YAML tab with inline editor
          - key: "yaml"
            label: "YAML"
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: "builtin"
                  typeName: pods
                  prefillValuesRequestIndex: 0
                  substractHeight: 400

          # Logs tab with live pod logs
          - key: "logs"
            label: "Logs"
            children:
              - type: PodLogs
                data:
                  id: pod-logs
                  cluster: "{2}"
                  namespace: "{reqsJsonPath[0]['.metadata.namespace']['-']}"
                  podName: "{reqsJsonPath[0]['.metadata.name']['-']}"
                  substractHeight: 400

          # Terminal tab with exec into pod
          - key: "terminal"
            label: "Terminal"
            children:
              - type: PodTerminal
                data:
                  id: pod-terminal
                  cluster: "{2}"
                  namespace: "{reqsJsonPath[0]['.metadata.namespace']['-']}"
                  podName: "{reqsJsonPath[0]['.metadata.name']['-']}"
                  substractHeight: 400

  {{- if $trivyEnabled }}
          # ------ PODS TAB ------
          - key: reports
            label: Reports
            children:
              - type: EnrichedTable
                data:
                  id: ds-pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/aquasecurity.github.io/v1alpha1/namespaces/{3}/vulnerabilityreports"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: factory-aquasecurity.github.io.v1alpha1.vulnerabilityreports
                  baseprefix: "/{{ $basePrefix }}"
                  withoutControls: true
                  # Build label selector from pod template labels
                  labelsSelector:
                    trivy-operator.resource.name: "{reqsJsonPath[0]['.metadata.name']['-']}"
                    trivy-operator.resource.kind: "{reqsJsonPath[0]['.kind']['-']}"
                  # Items path for Pods list
                  pathToItems: ".items[*].report.vulnerabilities"

          - key: cfg-reports
            label: CFG reports
            children:
              - type: EnrichedTable
                data:
                  id: ds-pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/aquasecurity.github.io/v1alpha1/namespaces/{3}/configauditreports"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: factory-aquasecurity.github.io.v1alpha1.configauditreports
                  baseprefix: "/{{ $basePrefix }}"
                  withoutControls: true
                  # Build label selector from pod template labels
                  labelsSelector:
                    trivy-operator.resource.name: "{reqsJsonPath[0]['.metadata.name']['-']}"
                    trivy-operator.resource.kind: "{reqsJsonPath[0]['.kind']['-']}"
                  # Items path for Pods list
                  pathToItems: ".items[*].report.checks"
  {{- end -}}
{{- end -}}
