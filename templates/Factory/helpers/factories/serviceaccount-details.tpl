{{- define "incloud-web-resources.factory.manifets.serviceaccount-details" -}}
{{- $key        := (default "serviceaccount-details" .key) -}}
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
    - serviceaccount-sidebar
  withScrollableMainContentCard: true
  urlsToFetch:
    - "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/serviceaccounts/{{ $resName }}"

  # Header row with badge and serviceaccount name
  data:
    - type: antdFlex
      data:
        id: header-row
        gap: 6
        align: center
        style:
          marginBottom: 24px
      children:
        # serviceaccount badge
        - type: antdText
          data:
            id: badge-serviceaccount
            text: SA
            title: serviceaccount
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
        # serviceaccount name
        - type: parsedText
          data:
            id: header-serviceaccount-name
            text: "{reqsJsonPath[0]['.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # Tabs with Details and YAML
    - type: antdTabs
      data:
        id: serviceaccount-tabs
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
                          # Title
                          - type: antdText
                            data:
                              id: details-title
                              text: "ServiceAccount details"
                              strong: true
                              style:
                                fontSize: 20
                                marginBottom: 12px

                          # Spacer
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

                              # Labels
                              - type: antdFlex
                                data:
                                  id: meta-labels-block
                                  vertical: true
                                  gap: 8
                                children:
                                 {{ include "incloud-web-resources.factory.labels" (dict
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/serviceaccounts/{{ $resName }}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/serviceaccounts/{{ $resName }}"
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

                      - type: antdCol
                        data:
                          id: col-right
                          span: 12
                        children:
                          - type: VisibilityContainer
                            data:
                              id: secrets-visibility
                              value: "{reqsJsonPath[0]['.secrets']['-']}"
                              style:
                                margin: 0
                                padding: 0
                            children:
                              # Secrets title
                              - type: antdText
                                data:
                                  id: secrets-title
                                  text: "Secrets"
                                  strong: true
                                  style:
                                    fontSize: 22
                              # Spacer
                              - type: Spacer
                                data:
                                  id: details-spacer
                                  "$space": 16
                              # Secrets table
                              - type: EnrichedTable
                                data:
                                  id: secrets-table
                                  fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/serviceaccounts/{{ $resName }}"
                                  clusterNamePartOfUrl: "{2}"
                                  customizationId: factory-serviceaccount-secrets
                                  baseprefix: "/{{ $basePrefix }}"
                                  withoutControls: true
                                  pathToItems: ".secrets"

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
                  typeName: serviceaccounts
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
{{- end -}}
