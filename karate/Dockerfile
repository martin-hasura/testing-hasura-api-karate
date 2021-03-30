FROM openjdk:jre-slim

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* 

ARG KARATE_VERSION=0.9.6

VOLUME /src/features
VOLUME /src/target

WORKDIR /src

RUN wget "https://dl.bintray.com/ptrthomas/karate/karate-$KARATE_VERSION.jar" -O karate.jar

CMD [ "java", "-jar", "karate.jar", "features/" ]
