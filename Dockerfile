# Liferay 6.2
#
# VERSION 0.0.9
#

# 0.0.1 : initial file with java 7u60
# 0.0.2 : change base image : java 7u71
# 0.0.3 : chain run commande to reduce image size (from 1.175 GB to 883.5MB), add JAVA_HOME env
# 0.0.4 : change to debian:wheezy in order to reduce image size (883.5MB -> 664.1 MB)
# 0.0.5 : bug with echo on setenv.sh
# 0.0.6 : liferay 6.2-ce-ga3 + java 7u79
# 0.0.7 : liferay 6.2-ce-ga4
# 0.0.8 : liferay 6.2-ce-ga5
# 0.0.9 : liferay 6.2-ce-ga6

# based on https://github.com/snasello/docker-liferay-6.2

FROM ubuntu:16.04

MAINTAINER Tamas Szerb

# Install base packages
RUN \
	apt-get update && \
	apt-get install -y curl unzip openjdk-8-jdk

# install liferay
RUN curl -O -s -k -L -C - http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.2.5%20GA6/liferay-portal-tomcat-6.2-ce-ga6-20160112152609836.zip \
	&& unzip liferay-portal-tomcat-6.2-ce-ga6-20160112152609836.zip -d /opt \
	&& rm liferay-portal-tomcat-6.2-ce-ga6-20160112152609836.zip

# add config for bdd
RUN /bin/echo -e '\nCATALINA_OPTS="$CATALINA_OPTS -Dexternal-properties=portal-bd-${DB_TYPE}.properties"' >> /opt/liferay-portal-6.2-ce-ga6/tomcat-7.0.62/bin/setenv.sh

# add configuration liferay file
ADD portal-bundle.properties /opt/liferay-portal-6.2-ce-ga6/portal-bundle.properties
ADD portal-bd-MYSQL.properties /opt/liferay-portal-6.2-ce-ga6/portal-bd-MYSQL.properties
ADD portal-bd-POSTGRESQL.properties /opt/liferay-portal-6.2-ce-ga6/portal-bd-POSTGRESQL.properties

# volumes
VOLUME /var/liferay-home

# Ports
EXPOSE 8080

# let Azure - Web App On Linux know the port https://docs.microsoft.com/en-us/azure/app-service-web/app-service-linux-faq
ENV PORT 8080
ENV WEBSITES_PORT 8080

# Set JAVA_HOME
#ENV JAVA_HOME /java

# EXEC
CMD ["run"]
ENTRYPOINT ["/opt/liferay-portal-6.2-ce-ga6/tomcat-7.0.62/bin/catalina.sh"]
