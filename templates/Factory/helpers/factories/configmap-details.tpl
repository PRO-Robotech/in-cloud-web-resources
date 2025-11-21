{{- define "incloud-web-resources.factory.manifets.configmap-details" -}}
{{- $key        := (default "configmap-details" .key) -}}
{{- $resName    := (default "{6}" .resName) -}}
{{- $basePrefix := (default "openapi-ui" .basePrefix) -}}

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
    - configmap-details

  # Enable scrollable content card for main section
  withScrollableMainContentCard: true

  # API endpoint for fetching ConfigMap details
  urlsToFetch:
    - cluster: "{2}"
      apiVersion: "v1"
      namespace: "{3}"
      plural: "configmaps"
      fieldSelector: "metadata.name={6}"

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

        # ConfigMap name
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
        defaultActiveKey: details
        items:
          # ------ DETAILS TAB ------
          - key: details
            label: Details
            children:
              # Main card container for details section
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
                      text: ConfigMap details
                      strong: true
                      style:
                        fontSize: 20px
                        marginBottom: 12px

                  # Spacer for visual separation
                  - type: Spacer
                    data:
                      id: details-spacer
                      $space: 16

                  # Grid layout: left and right columns
                  - type: antdRow
                    data:
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      # LEFT COLUMN: Metadata and links
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
                              # Resource name block
                              - type: antdFlex
                                data:
                                  id: field-name-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: field-name-label
                                      text: Name
                                      strong: true
                                  - type: parsedText
                                    data:
                                      id: field-name-value
                                      text: "{reqsJsonPath[0]['.metadata.name']['-']}"

                              # Namespace link block
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/configmaps/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~configmaps&labels="
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/configmaps/{6}"
                                    ) | nindent 34
                                  }}

                              # Creation time block
                              - type: antdFlex
                                data:
                                  id: created-time-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".metadata.creationTimestamp"
                                    "text" "Created"
                                    ) | nindent 30
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
                              #         text: Owner
                              #         strong: true
                              #     - type: parsedText
                              #       data:
                              #         id: owner-value
                              #         strong: true
                              #         text: "No owner"
                              #         style:
                              #           color: red

          # ------ YAML TAB ------
          - key: yaml
            label: YAML
            children:
              # YAML editor for resource manifest
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: builtin
                  plural: configmaps
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
{{- end -}}
