FROM openjdk:8-jdk-alpine
MAINTAINER Eugeniu Costetchi <costezki.eugengmail.com>

RUN apk update && apk upgrade && \
    apk add --update alpine-sdk bash git openssh tar git supervisor nodejs wget openssh expect

RUN apk add --update ca-certificates && rm -rf /var/cache/apk/* && \
  find /usr/share/ca-certificates/mozilla/ -name "*.crt" -exec keytool -import -trustcacerts \
  -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts -storepass changeit -noprompt \
  -file {} -alias {} \; && \
  keytool -list -keystore /usr/lib/jvm/java-1.8-openjdk/jre/lib/security/cacerts --storepass changeit

#ENV MAVEN_VERSION 3.5.2
ENV MAVEN_VERSION 3.6.0
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

# Getting the source code
RUN git clone https://github.com/linkedpipes/etl.git
RUN cd /etl && mvn install -Dmaven.test.skip=true
RUN cp /etl/executor/deploy/* /etl/deploy  && \
    cp /etl/executor-monitor/deploy/* /etl/deploy && \
    cp /etl/storage/deploy/* /etl/deploy && \
    cp /etl/frontend/deploy/* /etl/deploy
RUN chmod uag+rx /etl/deploy/executor.sh && \
    chmod uag+rx /etl/deploy/executor-monitor.sh && \
    chmod uag+rx /etl/deploy/frontend.sh && \
    chmod uag+rx /etl/deploy/storage.sh
COPY ./configuration_update.properties /etl/deploy/configuration.properties

# Install FDP-to-RDF-component:
ENV URL_FDP2RDF_COMPONENT https://github.com/opendatacz/lp-etl-components/raw/master/t-fdpToRdf/deploy/t-fdpToRdf.jar
RUN cd /etl/deploy/jars && \
    wget $URL_FDP2RDF_COMPONENT

# Add Timezone:
RUN apk add tzdata && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime && \
    echo "Europe/Berlin" > /etc/timezone

EXPOSE \
    # executor.webserver.port:
    8085 \
    # Webserver & URI dereferencable URI for pipelines + templates:
    8080 \
    # executor-monitor.webserver.port:
    8081 \
    # executor-monitor.ftp.port (command):
    2221 \
    # ftp data ports:
    2223-2226 \
    # external.port.start port for external services like Fuseki:
    3300 \
    # supervisor frontend
    9001

COPY ./supervisord.conf /etc/supervisord.conf
COPY ./start.sh /start.sh
CMD ["/bin/sh", "/start.sh"]


