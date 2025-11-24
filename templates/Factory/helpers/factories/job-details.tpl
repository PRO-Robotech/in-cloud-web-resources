{{- define "incloud-web-resources.factory.manifets.job-details" -}}
{{- $key            := (default "job-details" .key) -}}
{{- $resName        := (default "{6}" .resName) -}}
{{- $podFactoryName := (default "factory-/v1/pods" .podFactoryName) -}}
{{- $basePrefix     := (default "openapi-ui" .basePrefix) -}}

---
# Factory definition for Job details page
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  # Unique key for this view
  key: "{{ $key }}"

  # Tags for sidebar navigation
  sidebarTags:
    - jobs-details

  # Enables scrolling in the main content area
  withScrollableMainContentCard: true

  # API endpoint to fetch Job resource
  urlsToFetch:
    - cluster: "{2}"
      apiGroup: "{6}"
      apiVersion: "{7}"
      namespace: "{3}"
      plural: "{8}"
      fieldSelector: "metadata.name={9}"

  data:
    # === Header with icon, name, and job status ===
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
            value: "{reqsJsonPath[0]['.items.0.kind']['-']}"
            style:
              fontSize: 20px

        # Job name
        - type: parsedText
          data:
            id: header-name
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
            {{ include "incloud-web-resources.factory.statuses.job" . | nindent 12 }}

    # === Main content tabs ===
    - type: antdTabs
      data:
        id: job-tabs
        defaultActiveKey: "details"
        items:
          # ------ DETAILS TAB ------
          - key: "details"
            label: "Details"
            children:
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  - type: antdRow
                    data:
                      id: details-row
                      gutter: [48, 12]
                    children:
                      # === LEFT COLUMN: Job metadata ===
                      - type: antdCol
                        data:
                          id: left-column
                          span: 12
                        children:
                          - type: antdText
                            data:
                              id: job-details-title
                              text: "Job details"
                              strong: true
                              style:
                                fontSize: 20
                                marginBottom: 12px

                          - type: Spacer
                            data:
                              id: details-spacer
                              "$space": 16

                          - type: antdFlex
                            data:
                              id: left-column-flex
                              vertical: true
                              gap: 24
                            children:
                              # Job name
                              - type: antdFlex
                                data:
                                  id: name-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: name-label
                                      strong: true
                                      text: "Name"
                                  - type: parsedText
                                    data:
                                      id: name-value
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
                                  id: labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/jobs/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=batch~v1~jobs&labels="
                                      "jsonPath" ".items.0.metadata.labels"
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/jobs/{6}"
                                      "jsonPath" ".items.0.metadata.annotations"
                                      "pathToValue" "/metadata/annotations"
                                    ) | nindent 34
                                  }}

                              # Desired completions
                              - type: antdFlex
                                data:
                                  id: completions-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: completions-label
                                      strong: true
                                      text: "Desired completions"
                                  - type: parsedText
                                    data:
                                      id: completions-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.completions']['-']}"

                              # Parallelism
                              - type: antdFlex
                                data:
                                  id: parallelism-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: parallelism-label
                                      strong: true
                                      text: "Parallelism"
                                  - type: parsedText
                                    data:
                                      id: parallelism-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.parallelism']['-']}"

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
                                      emptyArrayErrorText: "-"
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


                              # Created timestamp
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


                      # === RIGHT COLUMN: Job status ===
                      - type: antdCol
                        data:
                          id: right-column
                          span: 12
                        children:
                          - type: antdText
                            data:
                              id: job-status-title
                              text: "Job status"
                              strong: true
                              style:
                                fontSize: 20
                                marginBottom: 12px

                          - type: Spacer
                            data:
                              id: status-spacer
                              "$space": 16

                          - type: antdFlex
                            data:
                              id: right-column-flex
                              vertical: true
                              gap: 24
                            children:
                              # Status (Complete/Failed)
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
                                  - type: antdFlex
                                    data:
                                      id: status-header-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      {{ include "incloud-web-resources.factory.statuses.job" . | nindent 38 }}

                              # Start time
                              - type: antdFlex
                                data:
                                  id: start-time-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".items.0.status.startTime"
                                    "text" "Start time"
                                    ) | nindent 34 
                                  }}

                              # Completion time
                              - type: antdFlex
                                data:
                                  id: completion-time-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".items.0.status.completionTime"
                                    "text" "Completion time"
                                    ) | nindent 34 
                                  }}

                              # Succeeded pods count
                              - type: antdFlex
                                data:
                                  id: succeeded-pods-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: succeeded-pods-label
                                      strong: true
                                      text: "Succeeded pods"
                                  - type: parsedText
                                    data:
                                      id: succeeded-pods-value
                                      text: "{reqsJsonPath[0]['.items.0.status.succeeded']['-']}"

                              # Active pods count
                              - type: antdFlex
                                data:
                                  id: active-pods-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: active-pods-label
                                      strong: true
                                      text: "Active pods"
                                  - type: parsedText
                                    data:
                                      id: active-pods-value
                                      text: "{reqsJsonPath[0]['.items.0.status.active']['-']}"

                              # Failed pods count
                              - type: antdFlex
                                data:
                                  id: failed-pods-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: failed-pods-label
                                      strong: true
                                      text: "Failed pods"
                                  - type: parsedText
                                    data:
                                      id: failed-pods-value
                                      text: "{reqsJsonPath[0]['.items.0.status.failed']['-']}"

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
                                apiGroup: "{6}"
                                apiVersion: "{7}"
                                namespace: "{3}"
                                plural: "{8}"
                              fieldSelector: 
                                metadata.name: "{9}"

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
                  apiGroup: "{6}"
                  apiVersion: "{7}"
                  namespace: "{3}"
                  plural: "{8}"
                  
          # ------ PODS TAB ------
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
                    cluster: "{2}"
                    apiVersion: "v1"
                    plural: "pods"
                    namespace: "{3}"
                  labelSelectorFull:
                    reqIndex: 0
                    pathToLabels:  '.items.0.spec.template.metadata.labels'
                  # Path to items list in the response
                  pathToItems: ".items"

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

{{- end -}}
