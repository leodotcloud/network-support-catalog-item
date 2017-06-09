version: '2'
services:
  network-support:
    image: leodotcloud/network-support:dev
    labels:
      io.rancher.container.create_agent: 'true'
      io.rancher.container.agent.role: 'environmentAdmin'
    command:
      - start.sh
      {{- if eq .Values.RANCHER_DEBUG "true" }}
      - --debug
      {{- end }}
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
  network-support-agent:
    image: leodotcloud/network-support-agent:dev
    labels:
      io.rancher.scheduler.global: 'true'
    pid: host
    privileged: true
    volumes:
      - /var/run/docker:/var/run/docker
      - /var/run/docker.sock:/var/run/docker.sock
    command:
      - network-support-agent
      {{- if ne .Values.BACKEND "ipsec" }}
      - --backend=${BACKEND}
      {{- end }}
      {{- if ne .Values.INFO_COLLECTION_INTERVAL "600000" }}
      - --info-collection-interval=${INFO_COLLECTION_INTERVAL}
      {{- end }}
      {{- if ne .Values.INFO_HISTORY_LENGTH "1000" }}
      - --info-history-length=${INFO_HISTORY_LENGTH}
      {{- end }}
      {{- if eq .Values.RANCHER_DEBUG "true" }}
      - --debug
      {{- end }}
    logging:
      driver: json-file
      options:
        max-size: 25m
        max-file: '2'
