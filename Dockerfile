FROM python:3.8

RUN apt-get update

ARG ELECTRUM_VERSION
ARG ELECTRUM_USER
ARG ELECTRUM_PASSWORD

ENV ELECTRUM_VERSION $ELECTRUM_VERSION
ENV ELECTRUM_USER $ELECTRUM_USER
ENV ELECTRUM_PASSWORD $ELECTRUM_PASSWORD
ENV ELECTRUM_HOME /home/$ELECTRUM_USER

RUN apt-get install libsecp256k1-0

RUN ln -s /usr/local/lib/libsecp256k1.so.0 /usr/lib/libsecp256k1.so.0

RUN pip3 install pycryptodomex

RUN adduser --disabled-password $ELECTRUM_USER && \
	pip3 install https://download.electrum.org/${ELECTRUM_VERSION}/Electrum-${ELECTRUM_VERSION}.tar.gz

RUN mkdir -p ${ELECTRUM_HOME}/.electrum/ /data && \
	ln -sf ${ELECTRUM_HOME}/.electrum/ /data && \
	chown ${ELECTRUM_USER} ${ELECTRUM_HOME}/.electrum /data

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
	&& ln -s /usr/local/bin/docker-entrypoint.sh

USER $ELECTRUM_USER
WORKDIR $ELECTRUM_HOME
VOLUME /data
EXPOSE 7777

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["electrum"]
