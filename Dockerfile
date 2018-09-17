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


RUN mkdir -p /app
COPY --from=builder /gradle/build/libs/DailyAdvisor.jar /app/
WORKDIR /app

# ENTRYPOINT [ "sh", "./updateAndRunDevelopment.sh" ]

CMD ["java", \
    "-Xmx128m", "-XX:+IdleTuningGcOnIdle", "-Xtune:virtualized", "-Xscmx128m", "-Xscmaxaot100m", "-Xshareclasses:cacheDir=/opt/shareclasses", \
    "-jar", "DailyAdvisor.jar", \
    "--spring.datasource.url=jdbc:postgresql://${POSTGRES_HOST}/daily_advisor", \
    "--spring.datasource.username=${DATASOURCE_USERNAME}", \
    "--spring.datasource.password=${DATASOURCE_PASSWORD}", \
    "--eureka.client.serviceurl.defaultzone=http://${EUREKA_URL}/eureka/", \
    "--server.port=${SERVER_PORT}", \
    "--facebook.client.clientId=${FACEBOOK_CLIENT_ID}", \
    "--facebook.client.clientSecret=${FACEBOOK_CLIENT_SECRET}", \
    "--google.client.clientId=${GOOGLE_CLIENT_ID}", \
    "--google.client.clientSecret=${GOOGLE_CLIENT_SECRET}", \
    "--spring.mail.username=${SRING_MAIL_USERNAME}", \
    "--spring.mail.password=${SPRING_MAIL_PASSWORD}" \
]
