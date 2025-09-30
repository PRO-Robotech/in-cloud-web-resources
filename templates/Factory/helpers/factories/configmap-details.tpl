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
    - configmap-sidebar

  # Enable scrollable content card for main section
  withScrollableMainContentCard: true

  # API endpoint for fetching ConfigMap details
  urlsToFetch:
    - "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/configmaps/{{ $resName }}"

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
        # Badge with resource short name
        - type: antdText
          data:
            id: header-badge
            text: CM
            title: ConfigMap
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
              backgroundColor: "#b48c78ff"
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif
              fontWeight: 400

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

                              # Labels display block
                              - type: antdFlex
                                data:
                                  id: labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/configmaps/{{ $resName }}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/configmaps/{{ $resName }}"
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
                  typeName: configmaps
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
{{- end -}}
