FROM opensuse:42.2
LABEL vendor="B1 Systems GmbH"
COPY ./create.sh /usr/local/bin
RUN /usr/local/bin/create.sh
COPY ./run-container.sh /usr/local/bin/run-container.sh

VOLUME /var/log
VOLUME /srv/git

ENTRYPOINT ["/usr/local/bin/run-container.sh"]
