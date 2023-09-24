FROM openjdk:11

RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/* 

VOLUME /src/features
VOLUME /src/target

WORKDIR /src

# https://github.com/karatelabs/karate/releases
RUN wget "https://github.com/karatelabs/karate/releases/download/v1.4.0/karate-1.4.0.jar" -O karate.jar

CMD [ "java", "-jar", "karate.jar", "features/" ]
