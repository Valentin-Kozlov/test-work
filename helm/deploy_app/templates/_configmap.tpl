{{- define "configmap" -}}
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: {{ .Values.image.imageName }}-config
  namespace: {{ .Values.namespace }}
  labels:
    {{- include "labels" . | nindent 4 }}
data:
{{ (.Files.Glob "files/configMapFiles/*").AsConfig | indent 4 -}}
{{- end }}