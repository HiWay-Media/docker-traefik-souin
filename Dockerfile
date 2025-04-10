
FROM alpine:3

RUN apk update && \
    apk add git && \
    git clone https://github.com/darkweak/souin.git /plugins-local/src/github.com/darkweak/souin \
      --depth 1 --single-branch --branch v1.6.50

FROM traefik:v2.7.3
COPY --from=0 /plugins-local /plugins-local
COPY --from=0 /plugins-local/src/github.com/darkweak/souin/plugins/traefik/traefik.yml /traefik.yml
COPY --from=0 /plugins-local/src/github.com/darkweak/souin/plugins/traefik/souin-configuration.yaml /souin-configuration.yaml
RUN ls -l

CMD ["--providers.docker=true", "--providers.docker.network=traefik-proxy", "--entrypoints.web.address=:80", "--entrypoints.websecure.address=:443", "--api.dashboard=true", "--api.insecure=true", "--experimental.localPlugins.souin.moduleName=github.com/darkweak/souin"]
