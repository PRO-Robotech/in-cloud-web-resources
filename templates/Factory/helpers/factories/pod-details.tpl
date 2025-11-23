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
    - pods-details
  withScrollableMainContentCard: true
  urlsToFetch:
    - cluster: "{2}"
      apiVersion: "{6}"
      namespace: "{3}"
      plural: "{7}"
      fieldSelector: "metadata.name={8}"
      
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
            value: "{reqsJsonPath[0]['.items.0.kind']['-']}"
            style:
              fontSize: 20px

        # Pod name next to badge
        - type: parsedText
          data:
            id: header-pod-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
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
                                      text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"

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
                                          "jsonPath" ".items.0.metadata.namespace"
                                          "factory" "namespace-details/v1/namespaces"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~pods&labels="
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

                              # Tolerations counter (kept as include)
                              - type: antdFlex
                                data:
                                  id: meta-tolerations-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.tolerations.block" (dict 
                                    "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{6}"
                                    "jsonPathToArray" ".items.0.spec.tolerations"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods/{6}"
                                      "jsonPath" ".items.0.metadata.annotations"
                                      "pathToValue" "/metadata/annotations"
                                    ) | nindent 34
                                  }}

                              - type: antdFlex
                                data:
                                  id: ref-link-block
                                  vertical: true
                                  gap: 8
                                children:
                                  - type: antdText
                                    data:
                                      id: meta-ref
                                      text: OwnerRef
                                      strong: true

                                  - type: OwnerRefs
                                    data:
                                      id: refs
                                      baseprefix: /openapi-ui
                                      cluster: '{2}'
                                      forcedNamespace: '{3}'
                                      reqIndex: 0
                                      errorText: error getting refs
                                      notArrayErrorText: refs on path are not arr
                                      emptyArrayErrorText: no refs
                                      isNotRefsArrayErrorText: objects in arr are not refs
                                      jsonPathToArrayOfRefs: ".items.0.metadata.ownerReferences"
                                      # keysToForcedLabel?: string | string[] // j
                                      baseFactoryClusterSceopedAPIKey: base-factory-clusterscoped-api
                                      baseFactoryClusterSceopedBuiltinKey: base-factory-clusterscoped-builtin
                                      baseFactoryNamespacedAPIKey: base-factory-namespaced-api
                                      baseFactoryNamespacedBuiltinKey: base-factory-namespaced-builtin
                                      baseNamespaceFactoryKey: namespace-details
                                      baseNavigationPlural: navigations
                                      baseNavigationName: navigation

                              # Created timestamp (kept as include)
                              - type: antdFlex
                                data:
                                  id: meta-created-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".items.0.metadata.creationTimestamp"
                                    "text" "Created"
                                  ) | nindent 38
                                  }}

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
                                      text: "{reqsJsonPath[0]['.items.0.spec.restartPolicy']['-']} restart"

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
                                      text: "{reqsJsonPath[0]['.items.0.spec.activeDeadlineSeconds']['-']}"

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
                                      text: "{reqsJsonPath[0]['.items.0.status.podIP']['-']}"

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
                                      text: "{reqsJsonPath[0]['.items.0.status.hostIP']['-']}"

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
                                          "jsonPath" ".items.0.spec.nodeName"
                                          "factory" "node-details/v1/nodes"
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
                                      text: "{reqsJsonPath[0]['.items.0.status.qosClass']['-']}"

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
                          value: "{reqsJsonPath[0]['.items.0.status.initContainerStatuses']['-']}"
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
                              customizationId: "container-status-init-containers-list"
                              baseprefix: "/openapi-ui"
                              withoutControls: true
                              pathToItems: .items.0.status.initContainerStatuses
                              k8sResourceToFetch: 
                                apiVersion: "v1"
                                plural: "pods"
                                namespace: "{3}"
                              fieldSelector: 
                                metadata.name: "{8}"

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
                          value: "{reqsJsonPath[0]['.items.0.status.containerStatuses']['-']}"
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
                              customizationId: "container-status-containers-list"
                              baseprefix: "/openapi-ui"
                              withoutControls: true
                              pathToItems: .items.0.status.containerStatuses
                              k8sResourceToFetch: 
                                apiVersion: "{6}"
                                namespace: "{3}"
                                plural: "{7}"
                              fieldSelector: 
                                metadata.name: "{8}"

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
                          value: "{reqsJsonPath[0]['.items.0.status.conditions']['-']}"
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

                          - type: EnrichedTable
                            data:
                              id: conditions-table
                              cluster: "{2}"
                              customizationId: factory-status-conditions
                              baseprefix: "/openapi-ui"
                              withoutControls: true
                              pathToItems: ".items.0.status.conditions"
                              k8sResourceToFetch: 
                                apiVersion: "{6}"
                                namespace: "{3}"
                                plural: "{7}"
                              fieldSelector: 
                                metadata.name: "{8}"

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
                  plural: pods
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  pathToData: .items.0
                  forcedKind: Pod
                  apiVersion: v1

          # Logs tab with live pod logs
          - key: "logs"
            label: "Logs"
            children:
              - type: PodLogs
                data:
                  id: pod-logs
                  cluster: "{2}"
                  namespace: "{reqsJsonPath[0]['.items.0.metadata.namespace']['-']}"
                  podName: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
                  substractHeight: 400

          # Terminal tab with exec into pod
          - key: "terminal"
            label: "Terminal"
            children:
              - type: PodTerminal
                data:
                  id: pod-terminal
                  cluster: "{2}"
                  namespace: "{reqsJsonPath[0]['.items.0.metadata.namespace']['-']}"
                  podName: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
                  substractHeight: 400

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
                    trivy-operator.resource.name: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
                    trivy-operator.resource.kind: "{reqsJsonPath[0]['.items.0.kind']['-']}"
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
