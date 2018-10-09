FROM openjdk:8-jdk-alpine as builder

RUN mkdir -p /gradle

ADD  build.gradle /gradle
ADD  settings.gradle /gradle
ADD  src /gradle/src
ADD  gradlew /gradle
ADD  gradle /gradle/gradle
WORKDIR /gradle
RUN ./gradlew build

FROM adoptopenjdk/openjdk8-openj9:x86_64-alpine-jdk8u181-b13_openj9-0.9.0-slim

ENV POSTGRES_HOST localhost
ENV DATASOURCE_USERNAME postgres
ENV DATASOURCE_PASSWORD postgres
ENV SERVER_PORT 8091
ENV FACEBOOK_CLIENT_ID clientId
ENV FACEBOOK_CLIENT_SECRET clientSecret
ENV GOOGLE_CLIENT_ID clientId
ENV GOOGLE_CLIENT_SECRET clientSecret
ENV SRING_MAIL_USERNAME mailserver
ENV SPRING_MAIL_PASSWORD password
ENV EUREKA_URL localhost:8761
ENV XMX 128m


RUN mkdir -p /app
COPY --from=builder /gradle/build/libs/DailyAdvisor.jar /app/
COPY run.sh /app/
WORKDIR /app

ENTRYPOINT [ "sh", "./run.sh"]
