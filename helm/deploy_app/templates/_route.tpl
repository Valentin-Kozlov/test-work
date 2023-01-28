{{- define "route" -}}
---
kind: Route
apiVersion: route.openshift.io/v1
metadata:
  name: {{ .Values.image.imageName }}
  namespace: {{ .Values.namespace }}
  labels:
    {{- include "labels" . | nindent 4 }}
  annotations:
    {{- if contains "zui" .Values.image.imageName }}
        {{- print "haproxy.router.openshift.io/rewrite-target: /" | nindent 4 }}
    {{- end }}
    haproxy.router.openshift.io/timeout: 120s
spec:
  host: {{ .Values.route.host }}
  {{- if  .Values.route.path }}
  path: {{ .Values.route.path }}
  {{- end }}
  to:
    kind: Service
    name: {{ .Values.image.imageName }}
    weight: 100
  port:
    targetPort: http
  tls:
    termination: edge
    insecureEdgeTerminationPolicy: Redirect
  wildcardPolicy: None
{{- end }}