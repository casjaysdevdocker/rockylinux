FROM rockylinux as build

RUN dnf update -y && \
  dnf install -y  \
  epel-release \
  bash \
  bash-completion

COPY ./bin/. /usr/local/bin/
COPY ./config/. /config/
COPY ./data/. /data/

FROM scratch

ARG BUILD_DATE="$(date +'%Y-%m-%d %H:%M')"

LABEL org.label-schema.name="rockylinux" \
  org.label-schema.description="containerized version of rockylinux" \
  org.label-schema.url="https://github.com/dockerize-it/rockylinux" \
  org.label-schema.vcs-url="https://github.com/dockerize-it/rockylinux" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.version=$BUILD_DATE \
  org.label-schema.vcs-ref=$BUILD_DATE \
  org.label-schema.license="WTFPL" \
  org.label-schema.vcs-type="Git" \
  org.label-schema.schema-version="latest" \
  org.label-schema.vendor="CasjaysDev" \
  maintainer="CasjaysDev <docker-admin@casjaysdev.com>"

ENV SHELL="/bin/bash" \
  TERM="xterm-256color" \
  HOSTNAME="casjaysdev-rockylinux" \
  TZ="${TZ:-America/New_York}"

WORKDIR /root
VOLUME ["/root","/config"]
EXPOSE 9090

COPY --from=build /. /

HEALTHCHECK CMD [ "/usr/local/bin/entrypoint-rockylinux.sh", "healthcheck" ]
ENTRYPOINT [ "/usr/local/bin/entrypoint-rockylinux.sh" ]
CMD [ "/usr/bin/bash", "-l" ]
