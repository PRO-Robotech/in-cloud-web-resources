{{- define "incloud-web-resources.factory.manifets.networkpolicy-details" -}}
{{- $key            := (default "networkpolicy-details" .key) -}}
{{- $trivyEnabled   := (default false .trivyEnabled) -}}
{{- $resName        := (default "{6}" .resName) -}}
{{- $podFactoryName := (default "factory-node-details-/v1/pods" .podFactoryName) -}}
{{- $basePrefix     := (default "openapi-ui" .basePrefix) -}}

---
apiVersion: front.in-cloud.io/v1alpha1
kind: Factory
metadata:
  name: "{{ $key }}"
spec:
  key: "{{ $key }}"
  withScrollableMainContentCard: true
  sidebarTags:
    - networkpolicy-details
  urlsToFetch:
    - cluster: "{2}"
      apiGroup: "{6}"
      apiVersion: "{7}"
      namespace: "{3}"
      plural: "{8}"
      fieldSelector: "metadata.name={9}"

  # Header row with badge and networkpolicy name
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
            value: "{reqsJsonPath[0]['.items.0.kind']['-']}"
            style:
              fontSize: 20px

        # networkpolicy name
        - type: parsedText
          data:
            id: networkpolicy-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # Tabs with Details, YAML, and Pods
    - type: antdTabs
      data:
        id: networkpolicy-tabs
        defaultActiveKey: "details"
        items:
          # Details tab
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
                      # Left column: metadata and config
                      - type: antdCol
                        data:
                          id: col-left
                          span: 12
                        children:
                          - type: antdText
                            data:
                              id: details-title
                              text: "NetworkPolicy details"
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
                                          "factory" "namespace-details/v1/namespaces"
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/networking.k8s.io/v1/namespaces/{3}/networkpolicies/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=networking.k8s.io~v1~networkpolicies&labels="
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
                                      "jsonPath" ".items.0.spec.podSelector.matchLabels"
                                      "basePrefix" $basePrefix
                                      "linkPrefix" "/openapi-ui/{2}/{3}/search?kinds=~v1~pods&labels="
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/networkpolicys/{6}"
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
                                    ) | nindent 34
                                  }}


                      # Right column: routing and ports
                      # - type: antdCol
                      #   data:
                      #     id: col-right
                      #     span: 12
                      #   children:
                      #     - type: antdText
                      #       data:
                      #         id: routing-title
                      #         text: "networkpolicy rules"
                      #         strong: true
                      #         style:
                      #           fontSize: 20
                      #           marginBottom: 12px

          # YAML tab
          - key: yaml
            label: YAML
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: api
                  plural: networkpolicies
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  pathToData: .items.0
                  forcedKind: NetworkPolicy
                  apiGroup: networking.k8s.io
                  apiVersion: v1

          # Pods tab
          - key: "pods"
            label: "Pod Selector"
            children:
              - type: EnrichedTable
                data:
                  id: pods-table
                  cluster: "{2}"
                  customizationId: "{{ $podFactoryName }}"
                  baseprefix: "/{{ $basePrefix }}"
                  labelSelectorFull:
                    reqIndex: 0
                    pathToLabels: ".items.0.spec.podSelector.matchLabels"
                  pathToItems: ".items"
                  k8sResourceToFetch: 
                    apiVersion: "v1"
                    plural: "pods"
                    namespace: "{3}"
                  # dataForControls:
                  #   plural: pods
                  #   apiVersion: v1

{{- end -}}
