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
    - serviceaccount-details
  withScrollableMainContentCard: true
  urlsToFetch:
    - cluster: "{2}"
      apiVersion: "v1"
      namespace: "{3}"
      plural: "serviceaccounts"
      fieldSelector: "metadata.name={6}"

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
        # factory badge
        - type: ResourceBadge
          data:
            id: factory-resource-badge
            value: "ServiceAccount"
            style:
              fontSize: 20px

        # serviceaccount name
        - type: parsedText
          data:
            id: header-serviceaccount-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/serviceaccounts/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~serviceaccounts&labels="
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/serviceaccounts/{6}"
                                      "jsonPath" ".items.0.metadata.annotations"
                                      "pathToValue" "/metadata/annotations"
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
                                    "req" ".items.0.metadata.creationTimestamp"
                                    "text" "Created"
                                  ) | nindent 38
                                  }}

                      - type: antdCol
                        data:
                          id: col-right
                          span: 12
                        children:
                          - type: VisibilityContainer
                            data:
                              id: secrets-visibility
                              value: "{reqsJsonPath[0]['.items.0.secrets']['-']}"
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
                                  cluster: "{2}"
                                  customizationId: factory-serviceaccount-secrets
                                  baseprefix: "/{{ $basePrefix }}"
                                  fieldSelector:
                                    metadata.name: "{6}"
                                  pathToItems: ".items.0.secrets"
                                  k8sResourceToFetch: 
                                    apiVersion: "v1"
                                    plural: "pods"
                                    namespace: "{3}"
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
                  plural: serviceaccounts
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  pathToData: .items.0
                  forcedKind: ServiceAccount
                  apiVersion: v1
{{- end -}}
