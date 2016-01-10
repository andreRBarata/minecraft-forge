FROM webhippie/minecraft-vanilla:1.7.10
MAINTAINER Thomas Boerger <thomas@webhippie.de>

RUN apk update; apk add python py-pip

ENV MINECRAFT_VERSION 1.7.10
ENV FORGE_VERSION 10.13.4.1558-1.7.10
ENV FORGE_URL http://files.minecraftforge.net/maven/net/minecraftforge/forge/${MINECRAFT_VERSION}-${FORGE_VERSION}/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar
ENV FORGE_JAR forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-universal.jar

ENV SERVER_MAXHEAP 2G
ENV SERVER_MINHEAP 1G
ENV SERVER_MAXPERM 428M
ENV SERVER_OPTS nogui
ENV SERVER_MOTD Minecraft
ENV SERVER_RCONPWD webhippie
ENV SERVER_DYNMAP true
ENV JAVA_OPTS -server -XX:+UseConcMarkSweepGC -Dfml.queryResult=confirm


RUN curl -o /minecraft/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar ${FORGE_URL} 2> /dev/null && \
  cd /minecraft && \
  java -jar forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar --installServer && \
  rm -f /minecraft/forge-${MINECRAFT_VERSION}-${FORGE_VERSION}-installer.jar

VOLUME ["/minecraft/merge", "/minecraft/world", "/minecraft/logs", "/minecraft/dynmap"]

ADD rootfs /
EXPOSE 25565 25575 8123



WORKDIR /minecraft
CMD ["/bin/s6-svscan","/etc/s6"]
