FROM ubuntu:22.04

ARG artifact_url=""
ADD ${artifact_url} /tmp
ADD compile-and-install-openssl3.sh /tmp
RUN bash /tmp/compile-and-install-openssl3.sh
ADD node_modules /usr/share/mongodb-crypt-library-version/node_modules
RUN apt-get update
RUN yes | unminimize
RUN apt-get install -y man-db
RUN apt-get install -y /tmp/*mongosh*.deb
RUN /usr/bin/mongosh --build-info
RUN env MONGOSH_RUN_NODE_SCRIPT=1 mongosh /usr/share/mongodb-crypt-library-version/node_modules/.bin/mongodb-crypt-library-version /usr/lib/mongosh_crypt_v1.so | grep -Eq '^mongo_(crypt|csfle)_v1-'
RUN man mongosh | grep -q tlsAllowInvalidCertificates
ENV MONGOSH_SMOKE_TEST_OS_HAS_FIPS_SUPPORT=1
ENTRYPOINT [ "mongosh" ]
