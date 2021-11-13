FROM alpine:latest

RUN apk add --no-cache supervisor samba
COPY ./samba-adduser.sh /usr/bin/samba-adduser
COPY ./supervisord.conf /etc/samba/supervisord.conf

USER root
CMD [ "supervisord", "-c", "/etc/samba/supervisord.conf" ]