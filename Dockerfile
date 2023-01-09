FROM alpine:3.15
RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache rsyslog bash gawk supervisor dovecot opendkim opendkim-utils ca-certificates postfix postfix-pcre && \
    rm -rf /var/cache/apk/*
# openkim
COPY opendkim/ /etc/opendkim/
RUN mkdir /etc/opendkim/keys
# supervisor
COPY config/supervisord.conf /etc/supervisor.conf
COPY supervisor-script/ /etc/supervisor-script/
RUN chmod +x /etc/supervisor-script/*.sh

RUN mkdir /config && \
    mv /etc/postfix/main.cf /config/main.cf && \
    mv /etc/postfix/master.cf /config/master.cf && \
    mv /etc/dovecot/dovecot.conf /config/dovecot.conf && \
    ln -s /config/main.cf /etc/postfix/main.cf && \
    ln -s /config/master.cf /etc/postfix/master.cf && \
    ln -s /config/dovecot.conf /etc/postfix/dovecot.conf
COPY mydestinations /etc/postfix/

#startup 
COPY run.bash /run.bash
RUN chmod +x /run.bash
EXPOSE 587 25
CMD ["/run.bash"]