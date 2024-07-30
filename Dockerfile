FROM cgr.dev/chainguard/maven:latest-dev as builder
USER root
WORKDIR /app
COPY . .
RUN mvn clean install

FROM cgr.dev/chainguard/jdk:latest-dev
USER root
WORKDIR /app
COPY --from=builder /app/target/demoapp.jar /app/
EXPOSE 8080
CMD ["java", "-jar","demoapp.jar"]