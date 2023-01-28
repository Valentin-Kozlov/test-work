{{- define "secret" -}}
---
apiVersion: v1
kind: Secret
metadata:
  name: {{ .Values.image.imageName }}
  namespace: {{ .Values.namespace }}
  labels:
    {{- include "labels" . | nindent 4 }}
type: Opaque
stringData: 
{{- if .Values.secret }}
{{- toYaml .Values.secret | nindent 2 }}
{{- end }}
{{- if .Values.fromFile.secret }}
{{- $root := . -}}
{{- range $path, $bytes := .Files.Glob "files/secretFiles/*" }}
{{ base $path | indent 2 }}: '{{ $root.Files.Get $path | b64enc }}'
{{- end }}
{{- end }}
{{- end }}