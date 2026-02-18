{{- define "microservice-b.name" -}}
microservice-b
{{- end }}

{{- define "microservice-b.fullname" -}}
{{ include "microservice-b.name" . }}
{{- end }}
