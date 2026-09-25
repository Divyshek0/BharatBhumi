FROM alpine:3.20 AS unpack
RUN apk add --no-cache unzip
COPY bharatbhumi-render-package.zip /tmp/source.zip
RUN mkdir /src && unzip -q /tmp/source.zip -d /src

FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /w
COPY --from=unpack /src/backend/core/ ./
RUN mvn -q -DskipTests package

FROM eclipse-temurin:21-jre
COPY --from=build /w/target/*.jar /app.jar
EXPOSE 10000
ENTRYPOINT ["sh", "-c", "if [ -n \"$DB_HOST\" ]; then export DB_URL=\"jdbc:postgresql://${DB_HOST}:${DB_PORT}/${DB_NAME}\"; fi; if [ -n \"$AI_HOSTPORT\" ]; then export AI_URL=\"http://$AI_HOSTPORT\"; fi; exec java -jar /app.jar"]
