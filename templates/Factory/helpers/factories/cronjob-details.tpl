{{- define "incloud-web-resources.factory.manifets.cronjob-details" -}}
{{- $key            := (default "cronjob-details" .key) -}}
{{- $resName        := (default "{6}" .resName) -}}
{{- $podFactoryName := (default "factory-/v1/pods" .podFactoryName) -}}
{{- $jobFactoryName := (default "factory-/batch/v1/jobs" .jobFactoryName) -}}
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
    - cronjobs-details

  # Enable scrollable content card for main section
  withScrollableMainContentCard: true

  # API endpoint for fetching CronJob details
  urlsToFetch:
    - cluster: "{2}"
      apiGroup: "{6}"
      apiVersion: "{7}"
      namespace: "{3}"
      plural: "{8}"
      fieldSelector: "metadata.name={9}"

    - cluster: "{2}"
      apiGroup: "metrics.k8s.io"
      apiVersion: "v1beta1"
      namespace: "{3}"
      plural: "pods"

  data:
    # === HEADER ROW ===
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

        # CronJob name
        - type: parsedText
          data:
            id: header-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # === MAIN TABS ===
    - type: antdTabs
      data:
        id: tabs-root
        defaultActiveKey: "details"
        items:
          # ------ DETAILS TAB ------
          - key: "details"
            label: "Details"
            children:
              # Main card container for details section
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  # Grid layout: left and right columns
                  - type: antdRow
                    data:
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      # LEFT COLUMN: Metadata, schedule, labels, etc.
                      - type: antdCol
                        data:
                          id: col-left
                          span: 12
                        children:
                          # Section title
                          - type: antdText
                            data:
                              id: cronjob-title
                              text: "CronJob details"
                              strong: true
                              style:
                                fontSize: 20
                                marginBottom: 12px

                          # Spacer for visual separation
                          - type: Spacer
                            data:
                              id: spacer-main
                              "$space": 16

                          # Vertical stack of fields
                          - type: antdFlex
                            data:
                              id: left-stack
                              vertical: true
                              gap: 24
                            children:
                              # Resource name block
                              - type: antdFlex
                                data:
                                  id: name-block
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

                              # Labels display block
                              - type: antdFlex
                                data:
                                  id: labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/cronjobs/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=batch~v1~cronjobs&labels="
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/cronjobs/{6}"
                                      "jsonPath" ".items.0.metadata.annotations"
                                      "pathToValue" "/metadata/annotations"
                                    ) | nindent 34
                                  }}

                              # Cron schedule string (crontab)
                              - type: antdFlex
                                data:
                                  id: schedule-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: schedule-label
                                      strong: true
                                      text: "Schedule"
                                  - type: parsedText
                                    data:
                                      id: schedule-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.schedule']['-']}"

                              # Suspend flag
                              - type: antdFlex
                                data:
                                  id: suspend-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: suspend-label
                                      strong: true
                                      text: "Suspend"
                                  - type: parsedText
                                    data:
                                      id: suspend-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.suspend']['-']}"

                              # Concurrency policy
                              - type: antdFlex
                                data:
                                  id: concurrency-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: concurrency-label
                                      strong: true
                                      text: "Concurrency policy"
                                  - type: parsedText
                                    data:
                                      id: concurrency-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.concurrencyPolicy']['-']}"

                              # StartingDeadlineSeconds
                              - type: antdFlex
                                data:
                                  id: starting-deadline-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: starting-deadline-label
                                      strong: true
                                      text: "Starting deadline seconds"
                                  - type: parsedText
                                    data:
                                      id: starting-deadline-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.startingDeadlineSeconds']['Not configured']}"

                              # Last schedule time (from status)
                              - type: antdFlex
                                data:
                                  id: last-schedule-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".items.0.status.lastScheduleTime"
                                    "text" "Last schedule time"
                                    ) | nindent 34
                                  }}

                              # Creation timestamp
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

                      # RIGHT COLUMN: Job template fields (completions, parallelism, deadlines)
                      - type: antdCol
                        data:
                          id: col-right
                          span: 12
                        children:
                          # Section title
                          - type: antdText
                            data:
                              id: job-title
                              text: "Job details"
                              strong: true
                              style:
                                fontSize: 20
                                marginBottom: 12px

                          # Spacer for visual separation
                          - type: Spacer
                            data:
                              id: spacer-job
                              "$space": 16

                          # Vertical stack of job fields
                          - type: antdFlex
                            data:
                              id: right-stack
                              vertical: true
                              gap: 24
                            children:
                              # Desired completions
                              - type: antdFlex
                                data:
                                  id: desired-completions-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: desired-completions-label
                                      strong: true
                                      text: "Desired completions"
                                  - type: parsedText
                                    data:
                                      id: desired-completions-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.jobTemplate.spec.completions']['-']}"

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
                                      text: "{reqsJsonPath[0]['.items.0.spec.jobTemplate.spec.parallelism']['-']}"

                              # ActiveDeadlineSeconds
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
                                      text: "{reqsJsonPath[0]['.items.0.spec.activeDeadlineSeconds']['Not configured']}"

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
                    pathToLabels:  ".items.0.spec.jobTemplate.spec.template.metadata.labels"
                  # Path to items list in the response
                  pathToItems: ".items"
                  additionalReqsDataToEachItem:
                    - 1

          # ------ JOBS TAB ------
          - key: jobs
            label: Jobs
            children:
              # Table of Jobs in the same namespace; filtered by CronJob's jobTemplate labels
              - type: EnrichedTable
                data:
                  id: jobs-table
                  cluster: "{2}"
                  customizationId: "{{ $jobFactoryName }}"
                  baseprefix: "/{{ $basePrefix }}"
                  # Build label selector from CronJob's job template metadata.labels
                  labelSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".items.0.spec.jobTemplate.metadata.labels"
                  # Items path for Jobs list
                  pathToItems: ".items"
                  k8sResourceToFetch: 
                    apiGroup: "batch"
                    apiVersion: "v1"
                    namespace: "{3}"
                    plural: "jobs"

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
