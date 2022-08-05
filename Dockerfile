FROM alpine:latest

RUN apk add --no-cache gettext supervisor samba
COPY ./files/smb.conf.template /etc/samba/smb.conf.template
COPY ./files/supervisord.conf /etc/samba/supervisord.conf
COPY ./files/start.sh /usr/libexec/start.sh

USER root
CMD [ "/usr/libexec/start.sh" ]
