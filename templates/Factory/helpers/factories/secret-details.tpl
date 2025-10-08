{{- define "incloud-web-resources.factory.manifets.secret-details" -}}
{{- $key        := (default "secret-details" .key) -}}
{{- $resName    := (default "{6}" .resName) -}}
{{- $basePrefix := (default "openapi-ui" .basePrefix) -}}

---
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  key: "{{ $key }}"
  sidebarTags:
    - secret-sidebar
  withScrollableMainContentCard: true
  urlsToFetch:
    - "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/secrets/{{ $resName }}"

  # Header row with badge and Secret name
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
            value: "{reqsJsonPath[0]['.kind']['-']}"
            style:
              fontSize: 20px

        # Secret name
        - type: parsedText
          data:
            id: header-secret-name
            text: "{reqsJsonPath[0]['.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # Tabs with Details and YAML
    - type: antdTabs
      data:
        id: secret-tabs
        defaultActiveKey: "details"
        items:
          # Details tab with metadata and spec info
          - key: "details"
            label: "Details"
            children:
              - type: ContentCard
                data:
                  id: details-card
                  style:
                    marginBottom: 24px
                children:
                  # Title
                  - type: antdText
                    data:
                      id: details-title
                      text: "Secret details"
                      strong: true
                      style:
                        fontSize: 20
                        marginBottom: 12px

                  # Spacer
                  - type: Spacer
                    data:
                      id: details-spacer
                      "$space": 16

                  # Two-column layout
                  - type: antdRow
                    data:
                      id: details-grid
                      gutter: [48, 12]
                    children:
                      # Left column: metadata
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
                              # Name block
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
                                  id: meta-labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/secrets/{{ $resName }}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~secrets&labels="
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/secrets/{{ $resName }}"
                                    ) | nindent 34
                                  }}

                              # Created timestamp
                              - type: antdFlex
                                data:
                                  id: meta-created-block
                                  vertical: true
                                  gap: 4
                                children:
                                  {{ include "incloud-web-resources.factory.time.create" (dict
                                    "req" ".metadata.creationTimestamp"
                                    "text" "Created"
                                  ) | nindent 38
                                  }}

                              # Owner block
                              # - type: antdFlex
                              #   data:
                              #     id: meta-owner-block
                              #     vertical: true
                              #     gap: 4
                              #   children:
                              #     - type: antdText
                              #       data:
                              #         id: meta-owner-label
                              #         strong: true
                              #         text: "Owner"
                              #     - type: antdFlex
                              #       data:
                              #         id: meta-owner-flex
                              #         gap: 6
                              #         align: center
                              #       children:
                              #         - type: parsedText
                              #           data:
                              #             id: owner-value
                              #             strong: true
                              #             text: "No owner"
                              #             style:
                              #               color: red

                      # Right column: type info
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
                              # Secret type
                              - type: antdFlex
                                data:
                                  id: secret-type-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: secret-type-label
                                      strong: true
                                      text: "Type"
                                  - type: parsedText
                                    data:
                                      id: secret-type-value
                                      text: "{reqsJsonPath[0]['.type']['-']}"

                              # Secret SA
                              - type: antdFlex
                                data:
                                  id: secret-sa-block
                                  vertical: true
                                  gap: 4
                                children:
                                  # SA Link
                                  {{ include "incloud-web-resources.factory.links.details" (dict
                                      "reqIndex" 0
                                      "type" "serviceaccount"
                                      "title" "ServiceAccount"
                                      "jsonPath" ".metadata.annotations['kubernetes.io/service-account.name']"
                                      "namespace" "{3}"
                                      "factory" "serviceaccount-details"
                                      "basePrefix" $basePrefix
                                    ) | nindent 34 
                                  }}

          # YAML tab
          - key: yaml
            label: YAML
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: builtin
                  typeName: secrets
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
{{- end -}}
