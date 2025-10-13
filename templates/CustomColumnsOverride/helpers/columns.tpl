{{- define "incloud-web-resources.cco.columns.icon-link-block" -}}
{{- $columnName       := (default ""            .columnName)      -}}
{{- $title            := (default ""            .title)           -}}
{{- $reqIndex         := (default 0             .reqIndex)        -}}
{{- $type             := (default ""            .type)            -}}
{{- $jsonPath         := (default ""            .jsonPath)        -}}
{{- $factory          := (default ""            .factory)         -}}
{{- $basePrefix       := (default "openapi-ui"  .basePrefix)      -}}
{{- $namespace        := (default ""            .namespace)       -}}
{{- $project          := (default ""            .project)         -}}

- jsonPath: {{ $jsonPath }}
  name: {{ $columnName }}
  type: factory
  customProps:
    disableEventBubbling: true
    items:
    - type: antdFlex
      data:
        id: resource-badge-link-row
        direction: row
        align: center
        gap: 6   # расстояние между иконкой и текстом
      children:
        - type: ResourceBadge
          data:
            id: example-resource-badge
            value: {{ $title }}
        {{ include "incloud-web-resources.factory.linkblock" (dict
            "reqIndex" $reqIndex
            "type" $type
            "jsonPath" $jsonPath
            "factory" $factory
            "basePrefix" $basePrefix
            "namespace" $namespace
            "project" $project
          ) | nindent 8
        }}
{{- end -}}

{{- define "incloud-web-resources.cco.columns.timeblock" -}}
{{- $columnName       := (default ""            .columnName)      -}}
{{- $jsonPath         := (default ""            .jsonPath)        -}}

- jsonPath: {{ $jsonPath }}
  name: {{ $columnName }}
  type: factory
  customProps:
    disableEventBubbling: true
    items:
    {{ include "incloud-web-resources.factory.timeblock" (dict
      "req" $jsonPath
      ) | nindent 4
    }}
{{- end -}}

{{- define "incloud-web-resources.cco.columns.parsed-text" -}}
{{- $columnName       := (default ""            .columnName)      -}}
{{- $jsonPath         := (default ""            .jsonPath)        -}}
{{- $text             := (default ""            .text)            -}}

- jsonPath: {{ $jsonPath }}
  name: {{ $columnName }}
  type: factory
  customProps:
    disableEventBubbling: true
    items:
      - type: parsedText
        data:
          id: {{ $columnName | nospace | lower }}-value
          text: "{reqsJsonPath[0]['.spec.minReplicas']['-']}"
{{- end -}}

{{- define "incloud-web-resources.cco.columns.labels" -}}
- jsonPath: .metadata.labels
  name: Labels
  type: array
{{- end -}}

{{- define "incloud-web-resources.cco.columns.owner" -}}
- jsonPath: .metadata.ownerReferences[*].name
  name: Owner
  type: array
{{- end -}}

{{- define "incloud-web-resources.cco.columns.pod-selector" -}}
{{- $i := (default 0 .reqIndex) -}}
{{- $type := (default "pod-selector" .type) -}}
{{- $title := (default "Pod selector" .title) -}}
{{- $jsonPath := (default ".spec.template.metadata.labels" .jsonPath) -}}
{{- $basePrefix := (default "openapi-ui" .basePrefix) -}}

- jsonPath: "{{ $jsonPath }}"
  name: Pod Selector
  type: factory
  customProps:
    disableEventBubbling: true
    items:
      # - type: antdText
      #   data:
      #     id: search-icon
      #     text: "🔎"
      #     strong: true
      #     style:
      #       fontSize: 14

      - type: LabelsToSearchParams
        data:
          id: {{ printf "%s-to-search-params" $type }}
          reqIndex: {{$i}}
          jsonPathToLabels: "{{ $jsonPath }}"
          linkPrefix: "{{ .linkPrefix }}"
          errorText: "No selector"
          maxTextLength: 11
          textLink: Search
{{- end -}}

{{- define "incloud-web-resources.cco.columns.labels-new" -}}
{{- $i := (default 0 .reqIndex) -}}
{{- $type := (default "labels" .type) -}}
{{- $title := (default "Labels" .title) -}}
{{- $jsonPath := (default ".metadata.labels" .jsonPath) -}}
{{- $endpoint := (default "" .endpoint) -}}
{{- $pathToValue := (default "/metadata/labels" .pathToValue) -}}
{{- $maxTagTextLength := (default 35 .maxTagTextLength) -}}
{{- $maxEditTagTextLength := (default 35 .maxEditTagTextLength) -}}
{{- $notificationSuccessMessage := (default "Updated successfully" .notificationSuccessMessage) -}}
{{- $notificationSuccessMessageDescription := (default "Labels have been updated" .notificationSuccessMessageDescription) -}}
{{- $modalTitle := (default "Edit labels" .modalTitle) -}}
{{- $modalDescriptionText := (default "" .modalDescriptionText) -}}
{{- $inputLabel := (default "false" .inputLabel) -}}
{{- $containerMarginTop := (default "-30px" .containerMarginTop) -}}
{{- $linkPrefix := (default "" .linkPrefix) -}}

- jsonPath: "{{ $jsonPath }}"
  name: Labels
  type: factory
  customProps:
    disableEventBubbling: true
    items:
      - type: Labels
        data:
          id: {{ printf "%s-editor" $type }}
          reqIndex: {{ $i }}
          jsonPathToLabels: "{{ $jsonPath }}"
          selectProps:
            maxTagTextLength: {{ $maxTagTextLength }}
          notificationSuccessMessage: "{{ $notificationSuccessMessage }}"
          notificationSuccessMessageDescription: "{{ $notificationSuccessMessageDescription }}"
          modalTitle: "{{ $modalTitle }}"
          modalDescriptionText: "{{ $modalDescriptionText }}"
          inputLabel: "{{ $inputLabel }}"
          #containerStyle:
          #  marginTop: "{{ $containerMarginTop }}"
          maxEditTagTextLength: {{ $maxEditTagTextLength }}
          endpoint: "{{ $endpoint }}"
          pathToValue: "{{ $pathToValue }}"
          editModalWidth: 650
          paddingContainerEnd: "24px"
          linkPrefix: "{{ $linkPrefix }}"
          verticalViewList: true
          readOnly: true
{{- end -}}
