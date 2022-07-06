FROM python:3.7-alpine AS build-env

RUN apk add --no-cache \
  gcc \
  musl-dev \
  libffi-dev

RUN pip install \
  skpy \
  aiohttp \
  pyyaml \
  prometheus_client

FROM python:3.7-alpine
LABEL maintainer="yutarasov@outlook.com"

COPY --from=build-env /usr/local/lib/python3.7/site-packages/ /usr/local/lib/python3.7/site-packages/

RUN apk add --no-cache alertmanager

ADD ./prometheus-skype-alerts /prometheus-skype-alerts
ADD ./prometheus_skype /prometheus_skype

RUN sed -i 's/yaml.load(f)/yaml.load(f, Loader=yaml.FullLoader)/' /prometheus-skype-alerts

EXPOSE 9478

CMD ["/usr/local/bin/python", "/prometheus-skype-alerts", "--config", "/config.yaml"]
