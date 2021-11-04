# Download Oracle client
# Using multi-stage build to allow injection of authentication credential if necessary
FROM curlimages/curl:latest as downloader
RUN curl --fail \
        --url https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-basic-linux.x64-21.3.0.0.0.zip \
        --output /tmp/instantclient-basic-linux.x64-21.3.0.0.0.zip && \
    curl --fail \
        --url https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-sqlplus-linux.x64-21.3.0.0.0.zip \
        --output /tmp/instantclient-sqlplus-linux.x64-21.3.0.0.0.zip && \
    # Tools: e.g. sqlldr
    curl --fail \
        --url https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-tools-linux.x64-21.3.0.0.0.zip \
        --output /tmp/instantclient-tools-linux.x64-21.3.0.0.0.zip




FROM ubuntu:20.04

LABEL org.opencontainers.image.revision="-"
LABEL org.opencontainers.image.source="https://github.com/klo2k/sqlplus-docker"

# Create "oracle" user (so we don't run as root)
# User has static uid+gid (help extensions) and cannot login via shell (security)
RUN \
    groupadd --gid 10001 oracle && \
    useradd \
        --uid 10001 --gid oracle \
        --create-home \
        --shell /usr/sbin/nologin \
        oracle && \
    usermod --lock oracle

# Install os dependencies
RUN apt update && \
    apt install -y --no-install-recommends \
      unzip libaio1 && \
    apt clean

# Install oracle client
COPY --from=downloader /tmp/instantclient-*.zip /tmp/
RUN mkdir -p /opt/oracle/ && \
    cd /opt/oracle && \
    ls -l /tmp/instantclient-*.zip && \
    unzip '/tmp/instantclient-*.zip' && \
    rm /tmp/instantclient-*.zip && \
    cd /opt/oracle/instantclient_21_3 && \
    echo '/opt/oracle/instantclient_21_3' > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig
ENV PATH="/opt/oracle/instantclient_21_3:${PATH}"

# Run as "oracle"
USER oracle

ENTRYPOINT [ "sqlplus" ]
