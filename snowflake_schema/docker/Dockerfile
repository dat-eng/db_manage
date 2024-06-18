FROM openjdk:11-jre-slim-buster as liquibase

# Install GNUPG for package vefification and WGET for file download
RUN apt-get update \
    && apt-get -yqq install krb5-user libpam-krb5 \
    && apt-get -y install gnupg wget unzip procps \
    && rm -rf /var/lib/apt/lists/*

# Add the liquibase user and step in the directory
RUN addgroup --gid 1001 liquibase
RUN adduser --disabled-password --uid 1001 --ingroup liquibase liquibase

# Make /liquibase directory and change owner to liquibase
RUN mkdir /liquibase && chown liquibase /liquibase

# VIM for testing purposes
# RUN apt-get update
# RUN apt-get install vim -y

WORKDIR /liquibase

USER liquibase

ENV LIQUIBASE_HOME /liquibase
ENV PATH $PATH:/liquibase
# ENV MYSQL_PASSWORD 

# Latest Liquibase Release Version
ARG LIQUIBASE_VERSION=4.24.0
RUN wget https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz
RUN tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz
RUN rm liquibase-${LIQUIBASE_VERSION}.tar.gz

# Copy directories/files into the image
COPY --chown=liquibase:liquibase ./conf/* /liquibase/conf/

RUN mkdir -p /liquibase/changelogs
COPY --chown=liquibase:liquibase ./changelogs/ /liquibase/changelogs
COPY --chown=liquibase:liquibase ./docker/docker-entrypoint.sh /liquibase
RUN chmod 755 /liquibase/docker-entrypoint.sh

RUN mkdir -p /liquibase/lib
COPY --chown=liquibase:liquibase ./lib/ /liquibase/lib

# Docker entrypoint script
ENTRYPOINT ["/liquibase/docker-entrypoint.sh"]
# CMD ["--help"]
