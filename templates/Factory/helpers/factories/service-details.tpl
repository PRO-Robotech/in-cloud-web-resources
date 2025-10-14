{{- define "incloud-web-resources.factory.manifets.service-details" -}}
{{- $key            := (default "service-details" .key) -}}
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
    - service-sidebar
  urlsToFetch:
    - "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/services/{6}"

  # Header row with badge and Service name
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
                              text: "Service details"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/services/{6}"
                                      "linkPrefix" "/openapi-ui/{2}/search?kinds=~v1~services&labels="
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
                                      "jsonPath" ".spec.selector"
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
                                      "endpoint" "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/services/{6}"
                                    ) | nindent 34
                                  }}

                              # Session affinity
                              - type: antdFlex
                                data:
                                  id: meta-session-affinity-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: meta-session-affinity-label
                                      strong: true
                                      text: "Session affinity"
                                  - type: parsedText
                                    data:
                                      id: meta-session-affinity-value
                                      text: "{reqsJsonPath[0]['.spec.sessionAffinity']['Not configured']}"

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

                      # Right column: routing and ports
                      - type: antdCol
                        data:
                          id: col-right
                          span: 12
                        children:
                          - type: antdText
                            data:
                              id: routing-title
                              text: "Service routing"
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
                              # Hostname
                              - type: antdFlex
                                data:
                                  id: service-hostname-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: service-hostname-label
                                      strong: true
                                      text: "Hostname"
                                  - type: parsedText
                                    data:
                                      id: service-hostname-value
                                      text: "{reqsJsonPath[0]['.metadata.name']['-']}.{reqsJsonPath[0]['.metadata.namespace']['-']}.svc.cluster.local"

                              # IP addresses block
                              - type: antdFlex
                                data:
                                  id: service-ip-block
                                  vertical: true
                                  gap: 12
                                children:
                                  # ClusterIP
                                  - type: antdFlex
                                    data:
                                      id: clusterip-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: clusterip-label
                                          strong: true
                                          text: "ClusterIP address"
                                      - type: parsedText
                                        data:
                                          id: clusterip-value
                                          text: "{reqsJsonPath[0]['.spec.clusterIP']['-']}"

                                  # LoadBalancerIP
                                  - type: antdFlex
                                    data:
                                      id: loadbalancerip-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: loadbalancerip-label
                                          strong: true
                                          text: "LoadBalancerIP address"
                                      - type: parsedText
                                        data:
                                          id: loadbalancerip-value
                                          text: "{reqsJsonPath[0]['.status.loadBalancer.ingress[0].ip']['Not Configured']}"

                              # Service port mapping
                              - type: antdFlex
                                data:
                                  id: service-port-mapping-block
                                  vertical: true
                                  gap: 4
                                children:
                                  - type: antdText
                                    data:
                                      id: service-port-mapping-label
                                      strong: true
                                      text: "Service port mapping"
                                  - type: EnrichedTable
                                    data:
                                      id: service-port-mapping-table
                                      fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/services/{6}"
                                      clusterNamePartOfUrl: "{2}"
                                      customizationId: "factory-service-details-port-mapping"
                                      baseprefix: "/{{ $basePrefix }}"
                                      pathToItems: ".spec.ports"

                              # Pod serving
                              - type: VisibilityContainer
                                data:
                                  id: service-pod-serving-vis
                                  value: "{reqsJsonPath[0]['.spec.selector']['-']}"
                                  style: { margin: 0, padding: 0 }
                                children:
                                  - type: antdFlex
                                    data:
                                      id: service-pod-serving-block
                                      vertical: true
                                      gap: 4
                                    children:
                                      - type: antdText
                                        data:
                                          id: service-pod-serving-label
                                          strong: true
                                          text: "Pod serving"
                                      - type: EnrichedTable
                                        data:
                                          id: service-pod-serving-table
                                          fetchUrl: "/api/clusters/{2}/k8s/apis/discovery.k8s.io/v1/namespaces/{3}/endpointslices"
                                          clusterNamePartOfUrl: "{2}"
                                          customizationId: "factory-service-details-endpointslice"
                                          baseprefix: "/{{ $basePrefix }}"
                                          labelsSelector:
                                            kubernetes.io/service-name: "{reqsJsonPath[0]['.metadata.name']['-']}"
                                          pathToItems: ".items[*].endpoints"
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
                  typeName: services
                  prefillValuesRequestIndex: 0
                  substractHeight: 400

          # Pods tab
          - key: "pods"
            label: "Pods"
            children:
              - type: VisibilityContainer
                data:
                  id: service-pod-serving-vis
                  value: "{reqsJsonPath[0]['.spec.selector']['-']}"
                  style: { margin: 0, padding: 0 }
                children:
                  - type: EnrichedTable
                    data:
                      id: pods-table
                      fetchUrl: "/api/clusters/{2}/k8s/api/v1/namespaces/{3}/pods"
                      clusterNamePartOfUrl: "{2}"
                      customizationId: "{{ $podFactoryName }}"
                      baseprefix: "/{{ $basePrefix }}"
                      
                      labelsSelectorFull:
                        reqIndex: 0
                        # TODO требуется обработка нулевого значения
                        pathToLabels: ".spec.selector"
                      pathToItems: ".items"
                      namespace: "{3}"
                      isNamespaced: true
                      dataForControls:
                        resource: pods
                        apiVersion: v1

  {{- if $trivyEnabled }}
          - key: config-reports
            label: Config reports
            children:
              - type: EnrichedTable
                data:
                  id: ds-pods-table
                  fetchUrl: "/api/clusters/{2}/k8s/apis/aquasecurity.github.io/v1alpha1/namespaces/{3}/configauditreports"
                  clusterNamePartOfUrl: "{2}"
                  customizationId: factory-aquasecurity.github.io.v1alpha1.configauditreports
                  baseprefix: "/{{ $basePrefix }}"
                  
                  # Build label selector from pod template labels
                  labelsSelector:
                    trivy-operator.resource.name: "{reqsJsonPath[0]['.metadata.name']['-']}"
                    trivy-operator.resource.kind: "{reqsJsonPath[0]['.kind']['-']}"
                  # Items path for Pods list
                  pathToItems: ".items[*].report.checks"
                  namespace: "{3}"
                  isNamespaced: true
                  dataForControls:
                    resource: configauditreports
                    apiVersion: v1alpha1
                    apiGroup: aquasecurity.github.io
  {{- end -}}
{{- end -}}
