{{- define "incloud-web-resources.api-table.links.details" -}}
{{- $i := (default 0 .reqIndex) -}}
{{- $type := (default "" .type) -}}
{{- $title := (default "" .title) -}}
{{- $jsonPath := (default "" .jsonPath) -}}
{{- $resource := (default "" .resource) -}}
{{- $ns := (default "" .namespace) -}}
{{- $proj := (default "" .project) -}}

{{- $nsPart := "" -}}
{{- if ne $ns "" }}
  {{- $nsPart = printf "%s/" $ns -}}
{{- end }}
{{- if ne $proj "" }}
  {{- $nsPart = printf "%s%s/" $nsPart $proj -}}
{{- end }}
- type: parsedText
  data:
    id: {{ printf "%s-title" $type }}
    strong: true
    text: "{{ $title }}"
    style:
      fontWeight: bold
- type: antdLink
  data:
    id: {{ printf "%s-link" $type }}
    text: "{reqsJsonPath[{{$i}}]['{{ $jsonPath }}']['-']}"
    href: "/openapi-ui/{2}/{{$nsPart}}api-table/{{ $resource }}"
{{- end -}}

{{- define "incloud-web-resources.api-table.linkblock" -}}
{{- $i := (default 0 .reqIndex) -}}
{{- $type := (default "" .type) -}}
{{- $jsonPath := (default "" .jsonPath) -}}
{{- $resource := (default "" .resource) -}}
{{- $ns := (default "" .namespace) -}}
{{- $proj := (default "" .project) -}}

{{- $nsPart := "" -}}
{{- if ne $ns "" }}
  {{- $nsPart = printf "%s/" $ns -}}
{{- end }}
  {{- if ne $proj "" }}
    {{- $nsPart = printf "%s%s/" $nsPart $proj -}}
  {{- end }}

- type: antdLink
  data:
    id: {{ printf "%s-link" $type }}
    text: "{reqsJsonPath[{{$i}}]['{{ $jsonPath }}']['-']}"
    href: "/openapi-ui/{2}/{{$nsPart}}api-table/{{ $resource }}"
{{- end -}}
