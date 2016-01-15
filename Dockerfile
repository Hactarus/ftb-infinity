FROM java:8-jre
MAINTAINER Hactarus

RUN apt-get update && \
	apt-get upgrade --yes --force-yes && \
	apt-get clean && \ 
	rm -rf /var/lib/apt/lists/* 

VOLUME ["/data"]
WORKDIR /data

RUN useradd -M -s /bin/false -d /data --uid 1000 minecraft

EXPOSE 25565

ENV UID=1000
ENV EULA=false
ENV UPGRADE=false

ENV MOTD="Docker FTB Infinity Evolved" \
	LEVEL=world \
	SEED= \
	PVP=true \
	WHITELIST= \
	DIFFICULTY=hard \
	OPS=_jeb

ENV ZIP_URL="http://addons-origin.cursecdn.com/files/2275/597/FTBInfinityServer-2.3.5-1.7.10.zip"

#ENV LAUNCHWRAPPER="net/minecraft/launchwrapper/1.12/launchwrapper-1.12.jar"
#ENV MCVER="1.7.10"
#ENV JAVA_OPTS="-server -Xms2048m -Xmx3072m -XX:MaxPermSize=256m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC"
#ENV JAR=FTBServer-1.7.10-1558.jar
#ENV JARFILE="minecraft_server.${MCVER}.jar"

ADD server.properties /data/server.properties
ADD start.sh /start.sh
RUN chmod 0755 /start.sh
CMD ["bash", "/start.sh"]
