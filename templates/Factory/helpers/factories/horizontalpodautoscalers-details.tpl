{{- define "incloud-web-resources.factory.manifets.horizontalpodautoscaler-details" -}}
{{- $key        := (default "horizontalpodautoscaler-details" .key) -}}
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
    - horizontalpodautoscaler-sidebar
  urlsToFetch:
    # API call to fetch HPA details by cluster, namespace, and name
    - "/api/clusters/{2}/k8s/apis/autoscaling/v2/namespaces/{3}/horizontalpodautoscalers/{{ $resName }}"

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
        # Badge for HorizontalPodAutoscaler
        - type: antdText
          data:
            id: badge-horizontalpodautoscaler
            text: HPA
            title: horizontalpodautoscalers
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
              backgroundColor: "#6ca100"
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif
              fontWeight: 400

        # Resource name
        - type: parsedText
          data:
            id: horizontalpodautoscaler-name
            text: "{reqsJsonPath[0]['.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # --- Tabs section (Details, YAML, etc.) --------------------------------
    - type: antdTabs
      data:
        id: horizontalpodautoscaler-tabs
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
                              text: "HorizontalPodAutoscaler details"
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
                                      text: "{reqsJsonPath[0]['.metadata.name']['-']}"

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

                              # Labels (key/value list with chips)
                              - type: antdFlex
                                data:
                                  id: meta-labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                  {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/horizontalpodautoscalers/{{ $resName }}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/horizontalpodautoscalers/{{ $resName }}"
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
                                    "req" ".metadata.creationTimestamp"
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
                              # Scale target reference
                              # TODO ожидаем компонента, который может ссылаться по Kind/APIGroup/Name
                              # - type: antdFlex
                              #   data:
                              #     id: horizontalpodautoscaler-target-block
                              #     vertical: true
                              #     gap: 4
                              #   children:
                              #     - type: antdText
                              #       data:
                              #         id: horizontalpodautoscaler-target-label
                              #         strong: true
                              #         text: "Scale Target"
                              #     - type: parsedText
                              #       data:
                              #         id: horizontalpodautoscaler-hostname-value
                              #         text: "{reqsJsonPath[0]['.spec.scaleTargetRef']['-']}"

                              # Minimum replicas
                              - type: antdFlex
                                data:
                                  id: horizontalpodautoscaler-min-replicas-block
                                  vertical: true
                                  gap: 12
                                children:
                                  - type: antdFlex
                                    data:
                                      id: min-replicas-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: min-replicas-label
                                          strong: true
                                          text: "Min replicas"
                                      - type: parsedText
                                        data:
                                          id: min-replicas-value
                                          text: "{reqsJsonPath[0]['.spec.minReplicas']['-']}"

                              # Maximum replicas
                              - type: antdFlex
                                data:
                                  id: horizontalpodautoscaler-max-replicas-block
                                  vertical: true
                                  gap: 12
                                children:
                                  - type: antdFlex
                                    data:
                                      id: max-replicas-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: max-replicas-label
                                          strong: true
                                          text: "Max replicas"
                                      - type: parsedText
                                        data:
                                          id: max-replicas-value
                                          text: "{reqsJsonPath[0]['.spec.maxReplicas']['-']}"

                              # Last scale time
                              - type: antdFlex
                                data:
                                  id: horizontalpodautoscaler-last-scale-time-block
                                  vertical: true
                                  gap: 12
                                children:
                                  - type: antdFlex
                                    data:
                                      id: last-scale-time-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: last-scale-time-label
                                          strong: true
                                          text: "Last scale time"
                                      - type: parsedText
                                        data:
                                          id: last-scale-time-value
                                          text: "{reqsJsonPath[0]['.status.lastScaleTime']['-']}"

                              # Current replicas
                              - type: antdFlex
                                data:
                                  id: horizontalpodautoscaler-current-scale-time-block
                                  vertical: true
                                  gap: 12
                                children:
                                  - type: antdFlex
                                    data:
                                      id: current-scale-time-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: current-scale-time-label
                                          strong: true
                                          text: "Current replicas"
                                      - type: parsedText
                                        data:
                                          id: current-scale-time-value
                                          text: "{reqsJsonPath[0]['.status.currentReplicas']['-']}"

                              # Desired replicas
                              - type: antdFlex
                                data:
                                  id: horizontalpodautoscaler-desired-scale-time-block
                                  vertical: true
                                  gap: 12
                                children:
                                  - type: antdFlex
                                    data:
                                      id: desired-scale-time-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: desired-scale-time-label
                                          strong: true
                                          text: "Desired replicas"
                                      - type: parsedText
                                        data:
                                          id: desired-scale-time-value
                                          text: "{reqsJsonPath[0]['.status.desiredReplicas']['-']}"


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
                              fetchUrl: "/api/clusters/{2}/k8s/apis/autoscaling/v2/namespaces/{3}/horizontalpodautoscalers/{{ $resName }}"
                              clusterNamePartOfUrl: "{2}"
                              customizationId: factory-status-conditions
                              baseprefix: "/{{ $basePrefix }}"
                              withoutControls: true
                              pathToItems: ".status.conditions"

          # --- YAML tab -----------------------------------------------------
          - key: "yaml"
            label: "YAML"
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: "builtin"
                  typeName: horizontalpodautoscalers
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
{{- end -}}
