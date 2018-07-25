FROM openjdk:8-jdk-alpine

RUN mkdir -p /backend
WORKDIR /DailyAdvisor-API

ADD /DailyAdvisor-API /DailyAdvisor-API

VOLUME ["/DailyAdvisor-API"]

ENTRYPOINT [ "sh", "./updateAndRunDevelopment.sh" ]
