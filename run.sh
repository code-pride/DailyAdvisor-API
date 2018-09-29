#!/bin/sh
# Run java application

java \
  -Xmx${XMX} -XX:+IdleTuningGcOnIdle -Xtune:virtualized -Xscmx128m -Xscmaxaot100m -Xshareclasses:cacheDir=/opt/shareclasses \
  -jar DailyAdvisor.jar \
  --spring.datasource.url=jdbc:postgresql://${POSTGRES_HOST}/daily_advisor \
  --spring.datasource.username=${DATASOURCE_USERNAME} \
  --spring.datasource.password=${DATASOURCE_PASSWORD} \
  --eureka.client.serviceUrl.defaultZone=http://${EUREKA_URL}/eureka/ \
  --server.port=${SERVER_PORT} \
  #--logging.level.root=DEBUG \
  --facebook.client.clientId=${FACEBOOK_CLIENT_ID} \
  --facebook.client.clientSecret=${FACEBOOK_CLIENT_SECRET} \
  --google.client.clientId=${GOOGLE_CLIENT_ID} \
  --google.client.clientSecret=${GOOGLE_CLIENT_SECRET} \
  --spring.mail.username=${SRING_MAIL_USERNAME} \
  --spring.mail.password=${SPRING_MAIL_PASSWORD} \
/