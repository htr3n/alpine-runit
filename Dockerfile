# syntax=docker/dockerfile:1

ARG ALPINE_VERSION=3

FROM alpine:${ALPINE_VERSION}

RUN  apk update && \
  apk add --no-cache bash runit && \
  mkdir -p /etc/runit/ /etc/service \
  echo "first:x:0:root" >> /etc/group && \
  echo "first:x:1001:0:First:/:/sbin/nologin" >> /etc/passwd && \
  echo "second:x:0:root" >> /etc/group && \
  echo "second:x:1002:0:Second:/:/sbin/nologin" >> /etc/passwd && \
  echo "third:x:0:root" >> /etc/group && \
  echo "third:x:1003:0:Third:/:/sbin/nologin" >> /etc/passwd

ADD runit/stages/* /etc/runit/
ADD service/first /etc/service/first
ADD service/second /etc/service/second
ADD service/third /etc/service/third

ENTRYPOINT [ "/sbin/runit-init"]
