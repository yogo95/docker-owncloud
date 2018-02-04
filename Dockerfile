FROM alpine:3.7

LABEL maintainer="NEGRO Y CASTRO, Eric <yogo95@zrim-everythng.eu>"

# Intall base
RUN apk update && \
    apk upgrade && \
    apk --update --update-cache add \
    bash \
    curl \
    tar \
    bzip2 \
    gzip \
    bzip2 \
    openssl \
    ca-certificates \
    git \
    tzdata \
    openntpd \
    su-exec \
    #
    # Intall PHP
    #
    mysql-client \
    postgresql \
    php7 \
    php7-mcrypt \
    php7-mbstring \
    php7-soap \
    php7-openssl \
    php7-gmp \
    php7-pdo_odbc \
    php7-json \
    php7-dom \
    php7-pdo \
    php7-zip \
    php7-mysqli \
    php7-sqlite3 \
    php7-apcu \
    php7-pdo_pgsql \
    php7-bcmath \
    php7-gd \
#    php7-xcache \
    php7-odbc \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-gettext \
    php7-xmlreader \
    php7-xmlrpc \
    php7-bz2 \
    php7-memcached \
#    php7-mssql \
    php7-iconv \
    php7-pdo_dblib \
    php7-curl \
    php7-ctype \
    php7-phar \
    php7-cli \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-xmlrpc \
    php7-ldap \
    php7-redis \
    php7-exif \
    php7-session \
    php7-xdebug \
    php7-ftp \
    php7-intl \
    php7-simplexml \
    zlib \
    php7-zlib \
    php7-posix \
    php7-imap \
    php7-calendar \
    php7-pcntl \
    php7-fileinfo \
    #
    # Install Apache2 for php
    #
    apache2 \
    php7-apache2 && \
    #
    # Clean
    #
    rm -f /var/cache/apk/* && \
    #
    # Initialize
    #
    mkdir -p /opt/zrim-everything

COPY scripts/*.sh /opt/zrim-everything/
RUN chmod a+x /opt/zrim-everything/*.sh && \
    ln -s /opt/zrim-everything/set-owncloud-permission.sh /usr/bin/set-owncloud-permission && \
    ln -s /opt/zrim-everything/occ.sh /usr/bin/occ

CMD ["/opt/zrim-everything/docker-cmd.sh"]

EXPOSE 80

# Downcloud owncloud
ARG OWNCLOUD_VERSION=10.0.6
RUN mkdir -p /opt/owncloud && \
    echo $OWNCLOUD_VERSION > /opt/owncloud/version.live.txt && \
    OWNCLOUD_PATH=/opt/owncloud/owncloud-$OWNCLOUD_VERSION && \
    curl -sLo - https://download.owncloud.org/community/owncloud-$OWNCLOUD_VERSION.tar.bz2 | tar xfj - -C /opt/owncloud/ && \
    mv /opt/owncloud/owncloud $OWNCLOUD_PATH && \
    # Now we are setting permission : Can have error message due to empty owncloud data
    set-owncloud-permission -d $OWNCLOUD_PATH/data -p $OWNCLOUD_PATH && \
    #
    # Set owncloud
    #
    APACHE_DOCUMENT_ROOT_PATH=/var/www/localhost/htdocs && \
    echo $APACHE_DOCUMENT_ROOT_PATH > /opt/owncloud/oc-apache-path.txt && \
    rm -Rf $APACHE_DOCUMENT_ROOT_PATH && \
    cp -a $OWNCLOUD_PATH $APACHE_DOCUMENT_ROOT_PATH

# Enable or not libreoffice api
#RUN apk --update --update-cache add \
#    libreoffice \
#    libreoffice-common \
#    libreoffice-writer \
#    libreoffice-calc && \
#    #
#    # Clean
#    #
#    rm -f /var/cache/apk/*

