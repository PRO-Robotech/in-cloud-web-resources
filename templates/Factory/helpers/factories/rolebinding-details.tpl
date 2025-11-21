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
    - rolebinding-details
  withScrollableMainContentCard: true
  urlsToFetch:
    - cluster: "{2}"
      apiGroup: "rbac.authorization.k8s.io"
      apiVersion: "v1"
      namespace: "{3}"
      plural: "rolebindings"
      fieldSelector: "metadata.name={6}"

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
        # factory badge
        - type: ResourceBadge
          data:
            id: factory-resource-badge
            value: RoleBinding
            style:
              fontSize: 20px

        # role binding name
        - type: parsedText
          data:
            id: service-name
            text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"
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
                                      text: "{reqsJsonPath[0]['.items.0.metadata.name']['-']}"

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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/rolebindings/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=rbac.authorization.k8s.io~v1~rolebindings&labels="
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
                                      "endpoint" "/api/clusters/{2}/k8s/apis/rbac.authorization.k8s.io/v1/namespaces/{3}/rolebindings/{6}"
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
                                      value: "{reqsJsonPath[0]['.items.0.roleRef.kind']['-']}"
                                      style:
                                        margin: 0
                                        padding: 0
                                      children:
                                        {{ include "incloud-web-resources.factory.links.details" (dict
                                            "reqIndex" 0
                                            "type" "role"
                                            "title" "TODO"
                                            "namespace" "{reqsJsonPath[0]['.items.0.metadata.namespace']}"
                                            "jsonPath" ".items.0.roleRef.name"
                                            "factory" "role-details"
                                            "basePrefix" $basePrefix
                                          ) | nindent 40 
                                        }}

                                  # TODO не работает корректно
                                  - type: VisibilityContainer
                                    data:
                                      id: conditions-visibility
                                      value: "{reqsJsonPath[0]['.items.0.roleRef.kind']['-']}"
                                      style:
                                        margin: 0
                                        padding: 0
                                      children:
                                        {{ include "incloud-web-resources.factory.links.details" (dict
                                            "reqIndex" 0
                                            "type" "cluster-role"
                                            "title" "ClusterRole"
                                            "jsonPath" ".items.0.roleRef.name"
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
                  type: "apis"
                  plural: rolebindings
                  prefillValuesRequestIndex: 0
                  substractHeight: 400
                  pathToData: .items.0
                  forcedKind: RoleBinding
                  apiVersion: v1
                  apiGroup: rbac.authorization.k8s.io
{{- end -}}
