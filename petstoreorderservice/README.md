# OrderService

A back-end Java Spring Boot microservice dedicated to managing Pet Store orders

# Getting Started

### Reference Documentation

* [Spring Cloud Azure developer guide](https://learn.microsoft.com/en-us/azure/developer/java/spring-framework/developer-guide-overview)
* [Azure Spring Data Cosmos client library for Java](https://learn.microsoft.com/en-us/java/api/overview/azure/spring-data-cosmos-readme?view=azure-java-stable)
* [Develop locally using the Azure Cosmos DB emulator](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-develop-emulator?tabs=docker-linux%2Ccsharp&pivots=api-nosql)

# Run application

### Prerequisites

* Install Java 17, e.g. via [sdkman](https://sdkman.io/usage)
* Install Docker Engine (Linux) or Docker Desktop (Windows, Mac)
* (Optional) Install [Cosmos DB emulator](https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-develop-emulator?tabs=docker-linux%2Ccsharp&pivots=api-nosql)

### Run without Cosmos DB emulator

```shell
mvn spring-boot:run \
-Dspring-boot.run.profiles=local \
-Dspring-boot.run.arguments="--ENABLE_COSMOS_DB_EMULATOR=false"
```

### Run with Cosmos DB emulator

#### Step 1. Launch Cosmos DB emulator, e.g via docker
```shell
docker run \
    --publish 8084:8081 \
    --publish 10250-10255:10250-10255 \
    --name linux-emulator \
    --detach \
    mcr.microsoft.com/cosmosdb/linux/azure-cosmos-emulator:latest
```

#### Step 2. Setup Cosmos DB via explorer
1. Navigate to Cosmos DB explorer
```shell
https://localhost:8084/_explorer/index.html
```
2. Create necessary databases and containers

#### Step 3. Install Cosmos DB SSL certificate

1. Make sure the `$JAVA_HOME` environment variable is pointing to `JDK17/bin` directory
2. (Linux, Mac) Import Cosmos DB certificate to java 17 by running the following script:
```shell
./scripts/install-cosmos-db-certificate.sh
```
3. (Windows) Manually extract and import Cosmos DB certificate to java 17

#### Step 3. Start application
```shell
mvn spring-boot:run \
-Dspring-boot.run.profiles=local \
-Dspring-boot.run.arguments="--ENABLE_COSMOS_DB_EMULATOR=true"
```
