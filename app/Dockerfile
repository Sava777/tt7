FROM gliderlabs/alpine:3.3

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    uwsgi-python \
    build-base \
    git \
    postgresql-dev \
    netcat-openbsd \
    mariadb-client \
    mariadb-dev \
    mariadb-libs \
  && pip install --upgrade pip \
  && rm -rf /var/cache/apk/* &&\
    addgroup django && \
    adduser -s /bin/bash -D -G django django && \
    mkdir /home/django/app && \
    git clone git://github.com/kirpit/django-sample-app.git /home/django/app && \
    chown -R django:django /home/django/app && \
    cd /home/django/app && \
    pip install MySQL-python && \
    pip install -r requirements.txt && \
    apk del musl-dev libc-dev g++ build-base && \
    apk del zlib-dev openssl-dev postgresql-dev mariadb-dev && \
    apk del python-dev && \
    apk del git

COPY . /home/django/app/
EXPOSE 8080
CMD /home/django/app/docker-entrypoint.sh
