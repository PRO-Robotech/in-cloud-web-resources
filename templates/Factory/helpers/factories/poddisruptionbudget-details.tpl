{{- define "incloud-web-resources.factory.manifets.poddisruptionbudget-details" -}}
{{- $key        := (default "poddisruptionbudget-details" .key) -}}
{{- $resName    := (default "{6}" .resName) -}}
{{- $basePrefix := (default "openapi-ui" .basePrefix) -}}

---
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  key: "{{ $key }}"
  withScrollableMainContentCard: true
  sidebarTags:
    - poddisruptionbudget-details
  urlsToFetch:
    # API call to fetch HPA details by cluster, namespace, and name
    - cluster: "{2}"
      apiGroup: "policy"
      apiVersion: "v1"
      namespace: "{3}"
      plural: "poddisruptionbudgets"
      fieldSelector: "metadata.name={6}"

  data:
    # --- Header section -----------------------------------------------------
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
            value: PodDisruptionBudget
            style:
              fontSize: 20px

        # Resource name
        - type: parsedText
          data:
            id: poddisruptionbudget-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # --- Tabs section (Details, YAML, etc.) --------------------------------
    - type: antdTabs
      data:
        id: poddisruptionbudget-tabs
        defaultActiveKey: "details"
        items:
          # --- Details tab --------------------------------------------------
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
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      # --- Left column: metadata & config -------------------
                      - type: antdCol
                        data:
                          id: col-left
                          span: 12
                        children:
                          - type: antdText
                            data:
                              id: details-title
                              text: "PodDisruptionBudget details"
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
                              id: col-left-stack
                              vertical: true
                              gap: 24
                            children:
                              # Resource name
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

                              # Namespace link (navigates to namespace details)
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
                                          "factory" "namespace-details"
                                          "basePrefix" $basePrefix
                                        ) | nindent 38
                                      }}

                              # Labels (key/value list with chips)
                              - type: antdFlex
                                data:
                                  id: meta-labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                  {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/poddisruptionbudgets/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=policy~v1~poddisruptionbudgets&labels="
                                      "jsonPath" ".items.0.metadata.labels"
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
                                      "jsonPath" ".items.0.spec.selector.matchLabels"
                                      "basePrefix" $basePrefix
                                      "linkPrefix" "/openapi-ui/{2}/{3}/search?kinds=~v1~pods&labels="
                                    ) | nindent 34
                                  }}

                              # Annotations (counter with expandable view)
                              - type: antdFlex
                                data:
                                  id: ds-annotations
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.annotations.block" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/poddisruptionbudgets/{6}"
                                      "jsonPath" ".items.0.metadata.annotations"
                                      "pathToValue" "/metadata/annotations"
                                    ) | nindent 34
                                  }}

                              # Creation timestamp
                              - type: antdFlex
                                data:
                                  id: meta-created-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".items.0.metadata.creationTimestamp"
                                    "text" "Created"
                                    ) | nindent 34
                                  }}

                              # Owner section (commented, not yet implemented)
                              # Could show controller/parent resource

                      # --- Right column: scaling settings -------------------
                      - type: antdCol
                        data:
                          id: col-right
                          span: 12
                        children:
                          - type: antdText
                            data:
                              id: routing-title
                              text: "Settings"
                              strong: true
                              style:
                                fontSize: 20
                                marginBottom: 12px

                          - type: Spacer
                            data:
                              id: routing-spacer
                              "$space": 16

                          - type: antdFlex
                            data:
                              id: col-right-stack
                              vertical: true
                              gap: 24
                            children:
                              - type: antdFlex
                                data:
                                  id: poddisruptionbudget-max-unavailable-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: poddisruptionbudget-max-unavailable-label
                                      strong: true
                                      text: "Max unavailable"
                                  - type: parsedText
                                    data:
                                      id: poddisruptionbudget-max-unavailable-value
                                      text: "{reqsJsonPath[0]['.items.0.spec.maxUnavailable']['-']}"

                              - type: antdFlex
                                data:
                                  id: col-right-stack
                                  vertical: true
                                  gap: 24
                                children:
                                  - type: antdFlex
                                    data:
                                      id: poddisruptionbudget-disruptions-allowed-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: poddisruptionbudget-disruptions-allowed-label
                                          strong: true
                                          text: "Max unavailable"
                                      - type: parsedText
                                        data:
                                          id: poddisruptionbudget-disruptions-allowed-value
                                          text: "{reqsJsonPath[0]['.items.0.status.disruptionsAllowed']['-']}"

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
                          value: "{reqsJsonPath[0]['.items.0.status.conditions']['-']}"
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
                              baseprefix: /{{ $basePrefix }}
                              cluster: "{2}"
                              customizationId: factory-status-conditions
                              k8sResourceToFetch: 
                                apiVersion: "v1"
                                apiGroup: "policy"
                                plural: "poddisruptionbudgets"
                                namespace: "{3}"
                              fieldSelector: 
                                metadata.name: "{6}"
                              pathToItems: ".items.0.status.conditions"
                              withoutControls: true

          # YAML tab
          - key: yaml
            label: YAML
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: apis
                  plural: poddisruptionbudgets
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  pathToData: .items.0
                  forcedKind: PodDisruptionBudget
                  apiVersion: v1
                  apiGroup: "policy"

{{- end -}}
