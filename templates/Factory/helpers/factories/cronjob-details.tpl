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
    - "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/cronjobs/{6}"

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
            value: "{reqsJsonPath[0]['.kind']['-']}"
            style:
              fontSize: 20px

        # CronJob name
        - type: parsedText
          data:
            id: header-name
            text: "{reqsJsonPath[0]['.metadata.name']['-']}"
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
                                      text: "{reqsJsonPath[0]['.spec.schedule']['-']}"

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
                                      text: "{reqsJsonPath[0]['.spec.suspend']['-']}"

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
                                      text: "{reqsJsonPath[0]['.spec.concurrencyPolicy']['-']}"

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
                                      text: "{reqsJsonPath[0]['.spec.startingDeadlineSeconds']['Not configured']}"

                              # Last schedule time (from status)
                              - type: antdFlex
                                data:
                                  id: last-schedule-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".status.lastScheduleTime"
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
                                    "req" ".metadata.creationTimestamp"
                                    "text" "Created"
                                    ) | nindent 34
                                  }}

                              # Owner information block
                              # - type: antdFlex
                              #   data:
                              #     id: owner-block
                              #     vertical: true
                              #     gap: 4
                              #   children:
                              #     - type: antdText
                              #       data:
                              #         id: owner-label
                              #         strong: true
                              #         text: "Owner"
                              #     - type: parsedText
                              #       data:
                              #         id: owner-value
                              #         strong: true
                              #         text: "No owner"
                              #         style:
                              #           color: red

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
                                      text: "{reqsJsonPath[0]['.spec.jobTemplate.spec.completions']['-']}"

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
                                      text: "{reqsJsonPath[0]['.spec.jobTemplate.spec.parallelism']['-']}"

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
                                      text: "{reqsJsonPath[0]['.spec.activeDeadlineSeconds']['Not configured']}"

                  # ---- VOLUMES SECTION ----
                  # TODO to be done
                  # - type: antdCol
                  #   data:
                  #     id: volumes-section
                  #     style:
                  #       marginTop: 10
                  #       padding: 10
                  #   children:
                  #     # Hide block if no volumes
                  #     - type: VisibilityContainer
                  #       data:
                  #         id: volumes-container
                  #         value: "{reqsJsonPath[0]['.spec.volumes']['-']}"
                  #         style:
                  #           margin: 0
                  #           padding: 0
                  #       children:
                  #         # Section title
                  #         - type: antdText
                  #           data:
                  #             id: volumes-title
                  #             text: "Volumes"
                  #             strong: true
                  #             style:
                  #               fontSize: 22
                  #               marginBottom: 32px
                  #         # Generic table rendering volumes list
                  #         - type: EnrichedTable
                  #           data:
                  #             id: volumes-table
                  #             fetchUrl: "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/cronjobs/{6}"
                  #             clusterNamePartOfUrl: "{2}"
                  #             customizationId: factory-cronjob-details-volume-list
                  #             baseprefix: "/{{ $basePrefix }}"
                  #             # Path inside CronJob manifest where volumes are located
                  #             pathToItems: ".spec.volumes"

                  # ---- INIT CONTAINERS SECTION ----
                  - type: antdCol
                    data:
                      id: init-containers-section
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      # Hide block if no init containers
                      - type: VisibilityContainer
                        data:
                          id: init-containers-container
                          value: "{reqsJsonPath[0]['.spec.jobTemplate.spec.template.spec.initContainers']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          {{ include "incloud-web-resources.factory.containers.table" (dict
                              "title" "Init containers"
                              "customizationId" "container-spec-init-containers-list"
                              "type" "init-containers"
                              "apiGroup" "apis/batch/v1"
                              "kind" "cronjobs"
                              "resourceName" $resName
                              "namespace" "{3}"
                              "jsonPath" ".spec.jobTemplate.spec.template.spec.initContainers"
                              "pathToItems" "['spec','jobTemplate','spec','template','spec','initContainers']"
                              "basePrefix" $basePrefix
                            ) | nindent 26
                          }}

                  # ---- CONTAINERS SECTION ----
                  - type: antdCol
                    data:
                      id: containers-section
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      # Hide block if no containers
                      - type: VisibilityContainer
                        data:
                          id: containers-container
                          value: "{reqsJsonPath[0]['.spec.jobTemplate.spec.template.spec.containers']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          {{ include "incloud-web-resources.factory.containers.table" (dict
                              "title" "Containers"
                              "customizationId" "container-spec-containers-list"
                              "type" "containers"
                              "apiGroup" "apis/batch/v1"
                              "kind" "cronjobs"
                              "resourceName" $resName
                              "namespace" "{3}"
                              "jsonPath" ".spec.jobTemplate.spec.template.spec.containers"
                              "pathToItems" "['spec','jobTemplate','spec','template','spec','containers']"
                              "basePrefix" $basePrefix
                            ) | nindent 26
                          }}

                  # ---- CONDITIONS SECTION ----
                  - type: antdCol
                    data:
                      id: conditions-section
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      # Hide block if no status.conditions
                      - type: VisibilityContainer
                        data:
                          id: conditions-container
                          value: "{reqsJsonPath[0]['.status.conditions']['-']}"
                          style:
                            margin: 0
                            padding: 0
                        children:
                          # Section title
                          - type: antdText
                            data:
                              id: conditions-title
                              text: "Conditions"
                              strong: true
                              style:
                                fontSize: 22
                          # Table rendering .status.conditions
                          - type: EnrichedTable
                            data:
                              id: conditions-table
                              fetchUrl: "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/cronjobs/{6}"
                              clusterNamePartOfUrl: "{2}"
                              customizationId: factory-status-conditions
                              baseprefix: "/{{ $basePrefix }}"
                              # Path to conditions array
                              pathToItems: ".status.conditions"

          # ------ YAML TAB ------
          - key: "yaml"
            label: "YAML"
            children:
              # YAML editor for resource manifest
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: "builtin"
                  typeName: cronjobs
                  prefillValuesRequestIndex: 0
                  substractHeight: 400

          # ------ PODS TAB ------
          - key: pods
            label: Pods
            children:
              # Table of Pods that match CronJob's job template labels
              - type: EnrichedTable
                data:
                  id: pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: "{{ $podFactoryName }}"
                  baseprefix: "/{{ $basePrefix }}"
                  # Build label selector from job template's pod labels
                  labelsSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".spec.jobTemplate.spec.template.metadata.labels"
                  # Items path for Pods list
                  pathToItems: ".items"


          # ------ JOBS TAB ------
          - key: jobs
            label: Jobs
            children:
              # Table of Jobs in the same namespace; filtered by CronJob's jobTemplate labels
              - type: EnrichedTable
                data:
                  id: jobs-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/jobs"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: "{{ $jobFactoryName }}"
                  baseprefix: "/{{ $basePrefix }}"
                  # Build label selector from CronJob's job template metadata.labels
                  labelsSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".spec.jobTemplate.metadata.labels"
                  # Items path for Jobs list
                  pathToItems: ".items"
{{- end -}}
