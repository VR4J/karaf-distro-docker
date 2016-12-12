FROM java:8-jdk
MAINTAINER Joery Vreijsen
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN apt-get update \
  && apt-get -y install maven\
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /opt/karaf;
RUN mkdir /tmp/src;

WORKDIR /tmp/src/

ADD . .

RUN mvn clean install; \
    tar --strip-components=1 -C /opt/karaf -xzf target/karaf-distro-docker-1.0-SNAPSHOT.tar.gz; \
    rm -rf /tmp/*

RUN chmod 755 /opt; \
    sed -i "21s/out/stdout/" /opt/karaf/etc/org.ops4j.pax.logging.cfg;

WORKDIR /opt/karaf

VOLUME ["/opt/karaf/deploy"]

EXPOSE 1099 8101 44444

CMD ["/opt/karaf/bin/karaf"]