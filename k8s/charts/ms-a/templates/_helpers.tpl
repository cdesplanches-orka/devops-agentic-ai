{{- define "microservice-a.name" -}}
microservice-a
{{- end }}

{{- define "microservice-a.fullname" -}}
{{ include "microservice-a.name" . }}
{{- end }}
