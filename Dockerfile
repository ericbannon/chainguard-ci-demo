FROM cgr.dev/chainguard/maven:latest-dev as builder
WORKDIR /app
COPY . .
RUN mvn clean install

FROM cgr.dev/chainguard/jdk:latest
WORKDIR /app
COPY --from=build /app/target/demoapp.jar /app/
EXPOSE 8080
CMD ["java", "-jar","demoapp.jar"]
