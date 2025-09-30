{{- define "incloud-web-resources.cco.columns.icon-link-block" -}}
{{- $columnName       := (default ""            .columnName)      -}}
{{- $text             := (default ""            .text)            -}}
{{- $title            := (default ""            .title)           -}}
{{- $backgroundColor  := (default "#a25792ff" .backgroundColor) -}}
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
    {{ include "incloud-web-resources.icon" (dict
        "text" $text
        "title" $title
        "backgroundColor" $backgroundColor
      )| nindent 4
    }}
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
- jsonPath: .spec.template.metadata.labels
  name: Pod Selector
  type: array
{{- end -}}
