{{/*

Copyright © 2020 Oliver Baehler

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/}}
{{- define "bedag-lib.template.bundleExtras" -}}
  {{- if and .values .context }}
    {{- if (has .type (list "deployment" "pod" "statefulset")) }}
      {{- if .values.serviceAccount }}
        {{- if and .values.serviceAccount.enabled .values.serviceAccount.create }}
- {{- include "bedag-lib.manifest.serviceaccount" (dict "values" .values.serviceAccount "context" .context) | nindent 2  }}
        {{- end }}
      {{- end }}
      {{- if .values.environment }}
        {{- $environment := .values.environment }}
        {{- if (include "bedag-lib.utils.environment.hasSecrets" $environment) }}
- apiVersion: v1
  kind: Secret
  metadata:
    name: {{ include "bedag-lib.utils.common.fullname" . }}-env
    labels: {{- include "lib.utils.common.labels" (dict "labels" .values.labels "context" .context)| nindent 6 }}
  type: Opaque
  data:
          {{- range $environment }}
            {{- if .secret }}
              {{- .name | nindent 4 }}: {{ include "lib.utils.strings.template" (dict "value" .value "context" $.context) | b64enc }}
            {{- end }}
          {{- end }}
        {{- end }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end -}}
