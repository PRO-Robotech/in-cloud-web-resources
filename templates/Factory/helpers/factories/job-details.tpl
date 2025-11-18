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
      group: "batch"
      version: "v1"
      namespace: "{3}"
      plural: "jobs"
      fieldSelector: "metadata.name={6}"

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
            value: "{reqsJsonPath[0]['.kind']['-']}"
            style:
              fontSize: 20px

        # Job name
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
                                      text: "{reqsJsonPath[0]['.spec.completions']['-']}"

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
                                      text: "{reqsJsonPath[0]['.spec.parallelism']['-']}"

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

                              # Created timestamp
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

                              # Owner reference
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
                                    "req" ".status.startTime"
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
                                    "req" ".status.completionTime"
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
                                      text: "{reqsJsonPath[0]['.status.succeeded']['-']}"

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
                                      text: "{reqsJsonPath[0]['.status.active']['-']}"

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
                                      text: "{reqsJsonPath[0]['.status.failed']['-']}"

                  # === Volumes table ===
                  # TODO to be done
                  # - type: antdCol
                  #   data:
                  #     id: volumes-column
                  #     style:
                  #       marginTop: 10
                  #       padding: 10
                  #   children:
                  #     - type: VisibilityContainer
                  #       data:
                  #         id: volumes-container
                  #         value: "{reqsJsonPath[0]['.spec.volumes']['-']}"
                  #         style:
                  #           margin: 0
                  #           padding: 0
                  #       children:
                  #         - type: antdText
                  #           data:
                  #             id: volumes-title
                  #             text: "Volumes"
                  #             strong: true
                  #             style:
                  #               fontSize: 22
                  #               marginBottom: 32px
                  #         - type: EnrichedTable
                  #           data:
                  #             id: volumes-table
                  #             fetchUrl: "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/jobs/{6}"
                  #             clusterNamePartOfUrl: "{2}"
                  #             customizationId: factory-job-details-volume-list
                  #             baseprefix: "/{{ $basePrefix }}"
                  #             
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
                              "apiGroup" "apis/batch/v1"
                              "kind" "jobs"
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
                              "apiGroup" "apis/batch/v1"
                              "kind" "jobs"
                              "resourceName" $resName
                              "namespace" "{3}"
                              "jsonPath" ".spec.template.spec.containers"
                              "pathToItems" "['spec','template','spec','containers']"
                              "basePrefix" $basePrefix
                            ) | nindent 26
                          }}


                  # === Conditions table ===
                  - type: antdCol
                    data:
                      id: conditions-column
                      style:
                        marginTop: 10
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
                              text: "Conditions"
                              strong: true
                              style:
                                fontSize: 22
                          - type: EnrichedTable
                            data:
                              id: conditions-table
                              fetchUrl: "/api/clusters/{2}/k8s/apis/batch/v1/namespaces/{3}/jobs/{6}"
                              clusterNamePartOfUrl: "{2}"
                              customizationId: factory-status-conditions
                              baseprefix: "/{{ $basePrefix }}"
                              pathToItems: ".status.conditions"

          # ------ YAML TAB ------
          - key: "yaml"
            label: "YAML"
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: "builtin"
                  typeName: jobs
                  prefillValuesRequestIndex: 0
                  substractHeight: 400

          # ------ PODS TAB ------
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
                  # Build label selector from Job's pod template labels
                  labelSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".spec.template.metadata.labels"
                  pathToItems: ".items"

          - key: events
            label: Events
            children:
              - type: Events
                data:
                  id: events
                  baseprefix: "/openapi-ui"
                  clusterNamePartOfUrl: "{2}"
                  wsUrl: "/api/clusters/{2}/openapi-bff-ws/events/eventsWs"
                  pageSize: 50
                  substractHeight: 315
                  limit: 40
                  fieldSelector:
                    regarding.kind: "{reqsJsonPath[0]['.kind']['-']}"
                    regarding.name: "{reqsJsonPath[0]['.metadata.name']['-']}"
                    regarding.namespace: "{reqsJsonPath[0]['.metadata.namespace']['-']}"
                    regarding.apiVersion: "{reqsJsonPath[0]['.apiVersion']['-']}"
                  baseFactoryNamespacedAPIKey: base-factory-namespaced-api
                  baseFactoryClusterSceopedAPIKey: base-factory-clusterscoped-api
                  baseFactoryNamespacedBuiltinKey: base-factory-namespaced-builtin
                  baseFactoryClusterSceopedBuiltinKey: base-factory-clusterscoped-builtin
                  baseNamespaceFactoryKey: namespace-details

{{- end -}}
