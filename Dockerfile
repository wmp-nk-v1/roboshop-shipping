FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B

FROM docker.io/redhat/ubi9:latest
RUN dnf install -y java-17-openjdk-headless && dnf clean all
WORKDIR /app
COPY --from=build /app/target/shipping.jar .
EXPOSE 8004
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["java", "-jar", "shipping.jar"]
