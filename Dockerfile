FROM alpine:latest

RUN apk add --no-cache supervisor samba
COPY ./files/smb.conf /etc/samba/smb.conf
COPY ./files/supervisord.conf /etc/samba/supervisord.conf
COPY ./files/start.sh /usr/libexec/start.sh

USER root
CMD [ "/usr/libexec/start.sh" ]
