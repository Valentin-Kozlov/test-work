{{- define "labels" -}}
app.kubernetes.io/name: {{ .Values.image.imageName }}
app.kubernetes.io/version: {{ .Values.image.tag }}
{{- if .Values.module }}
module: {{ .Values.module }}
{{- end }}
{{- end }}