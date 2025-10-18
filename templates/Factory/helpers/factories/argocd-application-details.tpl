{{- define "incloud-web-resources.factory.manifets.argocd-application-details" -}}
{{- $key        := (default "argocd-application-details" .key) -}}
{{- $resName    := (default "{6}" .resName) -}}
{{- $basePrefix := (default "openapi-ui" .basePrefix) -}}

---
# Factory definition for ArgoCD Application details page
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  key: "{{ $key }}"
  sidebarTags:
    - argocd-applications-details
  withScrollableMainContentCard: true
  urlsToFetch:
    - "/api/clusters/{2}/k8s/apis/argoproj.io/v1alpha1/namespaces/{3}/applications/{6}"

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
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  - type: antdText
                    data:
                      id: details-title
                      text: "Application details"
                      strong: true
                      style:
                        fontSize: 20
                        marginBottom: 12px
                  - type: Spacer
                    data:
                      id: details-spacer
                      "$space": 16
                  - type: antdRow
                    data:
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      # === LEFT COLUMN ===
                      - type: antdCol
                        data:
                          id: details-col-left
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: left-stack
                              vertical: true
                              gap: 24
                            children:
                              - type: antdFlex
                                data:
                                  id: field-name-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: field-name-label
                                      strong: true
                                      text: "Name"
                                  - type: parsedText
                                    data:
                                      id: field-name-value
                                      text: "{reqsJsonPath[0]['.metadata.name']['-']}"
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

                              - type: antdFlex
                                data:
                                  id: labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                  {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/apis/argoproj.io/v1alpha1/namespaces/{3}/applications/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=argoproj.io~v1alpha1~applications&labels="
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/argoproj.io/v1alpha1/namespaces/{3}/applications/{6}"
                                    ) | nindent 34
                                  }}

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
                      # === RIGHT COLUMN ===
                      - type: antdCol
                        data:
                          id: details-col-right
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: right-stack
                              vertical: true
                              gap: 24
                            children:
                              - type: antdFlex
                                data:
                                  id: health-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: health-label
                                      strong: true
                                      text: "Health Status"
                                  - type: parsedText
                                    data:
                                      id: health-value
                                      text: "{reqsJsonPath[0]['.status.health.status']['-']}"
                              - type: antdFlex
                                data:
                                  id: sync-status-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: sync-status-label
                                      strong: true
                                      text: "Current Sync Status"
                                  - type: antdFlex
                                    data:
                                      id: sync-status-row
                                      gap: 6
                                      align: center
                                      style:
                                        marginBottom: 24px
                                    children:
                                      - type: parsedText
                                        data:
                                          id: sync-status-value
                                          text: "{reqsJsonPath[0]['.status.sync.status']['-']}"
                                      - type: parsedText
                                        data:
                                          id: sync-revision-value
                                          text: "{reqsJsonPath[0]['.status.sync.revision']['-']}"
                              - type: antdFlex
                                data:
                                  id: target-revision-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: target-revision-label
                                      strong: true
                                      text: "Target Revision"
                                  - type: parsedText
                                    data:
                                      id: target-revision-value
                                      text: "{reqsJsonPath[0]['.spec.source.targetRevision']['-']}"
                              - type: antdFlex
                                data:
                                  id: project-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.links.details" (dict
                                      "reqIndex" 0
                                      "type" "project"
                                      "title" "Project"
                                      "jsonPath" ".spec.project"
                                      "factory" "argocd-appproject-details"
                                      "basePrefix" $basePrefix
                                      "namespace" "{3}"
                                    ) | nindent 34 
                                  }}

                              - type: antdFlex
                                data:
                                  id: destination-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: destination-label
                                      strong: true
                                      text: "Destination"
                                  - type: parsedText
                                    data:
                                      id: destination-value
                                      text: "{reqsJsonPath[0]['.spec.destination.server']['-']}"
                              - type: antdFlex
                                data:
                                  id: sync-policy-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: sync-policy-label
                                      strong: true
                                      text: "Sync Policy"
                                  - type: parsedText
                                    data:
                                      id: sync-policy-value
                                      text: "{reqsJsonPath[0]['.spec.syncPolicy']['-']}"

          # ------ YAML TAB ------
          - key: "yaml"
            label: "YAML"
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: "apis"
                  typeName: applications
                  apiGroup: argoproj.io
                  apiVersion: v1alpha1
                  prefillValuesRequestIndex: 0
                  substractHeight: 400

          # ------ RESOURCES TAB ------
          - key: "resources"
            label: "Resources"
            children:
              - type: EnrichedTable
                data:
                  id: resources-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/argoproj.io/v1alpha1/namespaces/{3}/applications/{6}"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: "factory-argocd-application-status-resources"
                  baseprefix: "/{{ $basePrefix }}"
                  pathToItems: ".status.resources"

          # ------ SYNC RESOURCES TAB ------
          - key: "sync-resources"
            label: "Sync Resources"
            children:
              - type: ContentCard
                data:
                  id: sync-status-card
                  style:
                    marginBottom: 24px
                children:
                  - type: antdText
                    data:
                      id: sync-status-title
                      text: "Sync Status details"
                      strong: true
                      style:
                        fontSize: 20
                        marginBottom: 12px
                  - type: Spacer
                    data:
                      id: sync-status-spacer
                      "$space": 16
                  - type: antdRow
                    data:
                      id: sync-status-grid
                      gutter: [48, 12]
                    children:
                      - type: antdCol
                        data:
                          id: sync-col-left
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: sync-left-stack
                              vertical: true
                              gap: 24
                            children:
                              - type: antdFlex
                                data:
                                  id: phase-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: phase-label
                                      strong: true
                                      text: "Phase"
                                  - type: parsedText
                                    data:
                                      id: phase-value
                                      text: "{reqsJsonPath[0]['.status.operationState.phase']['-']}"
                              - type: antdFlex
                                data:
                                  id: message-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: message-label
                                      strong: true
                                      text: "Message"
                                  - type: parsedText
                                    data:
                                      id: message-value
                                      text: "{reqsJsonPath[0]['.status.operationState.message']['-']}"
                              - type: antdFlex
                                data:
                                  id: initiated-by-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: initiated-by-label
                                      strong: true
                                      text: "Initiated By"
                                  - type: parsedText
                                    data:
                                      id: initiated-by-value
                                      text: "{reqsJsonPath[0]['.status.operationState.operation.initiatedBy.username']['-']}"
                      - type: antdCol
                        data:
                          id: sync-col-right
                          span: 12
                        children:
                          - type: antdFlex
                            data:
                              id: sync-right-stack
                              vertical: true
                              gap: 24
                            children:
                              - type: antdFlex
                                data:
                                  id: started-at-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".status.operationState.startedAt"
                                    "text" "Started At"
                                    ) | nindent 38
                                  }}
                              - type: antdFlex
                                data:
                                  id: finished-at-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".status.operationState.finishedAt"
                                    "text" "Finished At"
                                    ) | nindent 38
                                  }}

                  - type: antdCol
                    data:
                      id: last-synced-section
                      style:
                        marginTop: 32px
                        padding: 16px
                    children:
                      - type: antdText
                        data:
                          id: last-synced-title
                          text: "Resources Last Synced"
                          strong: true
                          style:
                            fontSize: 22
                            marginBottom: 32px
                      - type: EnrichedTable
                        data:
                          id: last-synced-table
                          fetchUrl: "/api/clusters/{2}/k8s/apis/argoproj.io/v1alpha1/namespaces/{3}/applications/{6}"
                          clusterNamePartOfUrl: "{2}"
                          customizationId: "factory-argocd-application-resources"
                          baseprefix: "/{{ $basePrefix }}"
                          pathToItems: ".status.operationState.syncResult.resources"

          # ------ HISTORY TAB ------
          - key: "history"
            label: "History"
            children:
              - type: EnrichedTable
                data:
                  id: history-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/argoproj.io/v1alpha1/namespaces/{3}/applications/{6}"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: "factory-argocd-application-status-history"
                  baseprefix: "/{{ $basePrefix }}"
                  pathToItems: ".status.history"
{{- end }}
