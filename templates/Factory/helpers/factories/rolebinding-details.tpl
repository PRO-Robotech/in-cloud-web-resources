{{- define "incloud-web-resources.factory.manifets.rolebinding-details" -}}
{{- $key        := (default "rolebinding-details" .key) -}}
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
    - rolebinding-sidebar
  withScrollableMainContentCard: true
  urlsToFetch:
    - "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/rolebindings/{{ $resName }}"

  # Header row with badge and rolebinding name
  data:
    - type: antdFlex
      data:
        id: header-row
        gap: 6
        align: center
        style:
          marginBottom: 24px
      children:
        # Service badge
        - type: antdText
          data:
            id: badge-service
            text: RB
            title: rolebindings
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
        # Service name
        - type: parsedText
          data:
            id: service-name
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
                              text: "RoleBinding details"
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/rolebindings/{{ $resName }}"
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/rolebindings/{{ $resName }}"
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
                                  # TODO не работает корректно
                                  - type: VisibilityContainer
                                    data:
                                      id: conditions-visibility
                                      value: "{reqsJsonPath[0]['.roleRef.kind']['-']}"
                                      style:
                                        margin: 0
                                        padding: 0
                                      children:
                                        {{ include "incloud-web-resources.factory.links.details" (dict
                                            "reqIndex" 0
                                            "type" "role"
                                            "title" "TODO"
                                            "namespace" "{reqsJsonPath[0]['.metadata.namespace']}"
                                            "jsonPath" ".roleRef.name"
                                            "factory" "role-details"
                                            "basePrefix" $basePrefix
                                          ) | nindent 40 
                                        }}

                                  # TODO не работает корректно
                                  - type: VisibilityContainer
                                    data:
                                      id: conditions-visibility
                                      value: "{reqsJsonPath[0]['.roleRef.kind']['-']}"
                                      style:
                                        margin: 0
                                        padding: 0
                                      children:
                                        {{ include "incloud-web-resources.factory.links.details" (dict
                                            "reqIndex" 0
                                            "type" "cluster-role"
                                            "title" "ClusterRole"
                                            "jsonPath" ".roleRef.name"
                                            "factory" "clusterrole-details"
                                            "basePrefix" $basePrefix
                                          ) | nindent 40 
                                        }}

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
                  typeName: rolebindings
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
{{- end -}}
