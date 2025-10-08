{{- define "incloud-web-resources.factory.manifets.role-details" -}}
{{- $key        := (default "role-details" .key) -}}
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
    - role-sidebar
  withScrollableMainContentCard: true
  urlsToFetch:
    - "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/roles/{{ $resName }}"

  # Header row with badge and role name
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

        # role name
        - type: parsedText
          data:
            id: role-name
            text: "{reqsJsonPath[0]['.metadata.name']['-']}"
            style:
              fontSize: 20px
              lineHeight: 24px
              fontFamily: RedHatDisplay, Overpass, overpass, helvetica, arial, sans-serif

    # Tabs with Details, YAML, and Pods
    - type: antdTabs
      data:
        id: service-tabs
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
                              text: "Role details"
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
                                      text: "{reqsJsonPath[0]['.metadata.name']['-']}"

                              # Namespace link (kept as include)
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/roles/{{ $resName }}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=rbac.authorization.k8s.io~v1~roles&labels="
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/roles/{{ $resName }}"
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
                                    ) | nindent 34
                                  }}

                              # Owner
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
                              #         - type: antdText
                              #           data:
                              #             id: meta-owner-fallback
                              #             text: "No owner"
                              #             style:
                              #               color: "#FF0000"

                  - type: antdCol
                    data:
                      id: rule-col
                      style:
                        marginTop: 10
                        padding: 10
                    children:
                      - type: antdText
                        data:
                          id: rule-title
                          text: "Rules"
                          strong: true
                          style:
                            fontSize: 22
                      # Conditions table
                      - type: EnrichedTable
                        data:
                          id: conditions-table
                          fetchUrl: "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/roles/{{ $resName }}"
                          clusterNamePartOfUrl: "{2}"
                          customizationId: factory-k8s-rbac-rules
                          baseprefix: "/{{ $basePrefix }}"
                          withoutControls: true
                          pathToItems: ".rules"

          # YAML tab
          - key: "yaml"
            label: "YAML"
            children:
              - type: YamlEditorSingleton
                data:
                  id: yaml-editor
                  cluster: "{2}"
                  isNameSpaced: true
                  type: "builtin"
                  typeName: roles
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
{{- end -}}