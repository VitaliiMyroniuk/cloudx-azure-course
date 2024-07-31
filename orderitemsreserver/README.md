# Getting Started

### Reference Documentation

* [Azure Functions Java developer guide](https://learn.microsoft.com/en-us/azure/azure-functions/functions-reference-java)
* [Azure Functions Plugin for Gradle](https://github.com/microsoft/azure-gradle-plugins/tree/master/azure-functions-gradle-plugin)
* [host.json reference for Azure Functions 2.x and later](https://learn.microsoft.com/en-us/azure/azure-functions/functions-host-json)
* [Quickstart: Azure Blob Storage client library for Java](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-java?tabs=powershell%2Cmanaged-identity%2Croles-azure-portal%2Csign-in-azure-cli&pivots=blob-storage-quickstart-scratch)
* [Azure Service Bus trigger for Azure Functions](https://learn.microsoft.com/en-us/azure/azure-functions/functions-bindings-service-bus-trigger)
* [Develop Azure Functions locally using Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=linux%2Cisolated-process%2Cnode-v4%2Cpython-v2%2Chttp-trigger%2Ccontainer-apps&pivots=programming-language-java#install-the-azure-functions-core-tools)
* [Use the Azurite emulator for local Azure Storage development](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite)

# Run locally

### Prerequisites

* Install Java 21, e.g. via [sdkman](https://sdkman.io/usage)
* Install
  the [Azure Functions Core Tools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Cisolated-process%2Cnode-v4%2Cpython-v2%2Chttp-trigger%2Ccontainer-apps&pivots=programming-language-java#install-the-azure-functions-core-tools).
  On Windows could also be installed via [winget](https://winget.run/pkg/Microsoft/Azure.FunctionsCoreTools)

* Configure Azure Functions Core Tools to use Java 21 by either
    * setting `JAVA_HOME` environment variable, or
    * update `<azure-functions-core-tools-4-home-dir>\workers\java\worker.config.json` so that `defaultExecutablePath`
      points to Java 21 executable
* Install the [Azurite](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite) emulator

### Build and Run

```shell
./gradlew clean azureFunctionRun
```

### Test

```shell
curl -X POST 'http://localhost:7071/api/orders' \
--header 'Content-Type: application/json' \
--data-raw '{
  "id": "9EE430AE58D307433B5A30E94A5F5A16",
  "email": "anonymous.user@gmail.com",
  "products": [
    {
      "id": 10,
      "name": "DeWalt DCH033 3kg 18V 2 x 4.0Ah",
      "photoURL": "http://petstore-image-storage/10?size=medium",
      "tags": [
        {
          "id": 1,
          "name": "2 x 2Ah Li-Ion Batteries"
        }
      ],
      "quantity": 1
    }
  ],
  "shipDate": "2024-07-03T15:28:02.825274+03:00",
  "status": "placed",
  "complete": false
}'
```

# Run on Azure

### Build and Deploy

```shell
./gradlew clean azureFunctionsDeploy
```

### Test

```shell
curl -X POST 'https://petstore-order-items-reserver.azurewebsites.net/api/orders' \
--header 'Content-Type: application/json' \
--data-raw '{
  "id": "9EE430AE58D307433B5A30E94A5F5A16",
  "email": "anonymous.user@gmail.com",
  "products": [
    {
      "id": 10,
      "name": "DeWalt DCH033 3kg 18V 2 x 4.0Ah",
      "photoURL": "http://petstore-image-storage/10?size=medium",
      "tags": [
        {
          "id": 1,
          "name": "2 x 2Ah Li-Ion Batteries"
        }
      ],
      "quantity": 1
    }
  ],
  "shipDate": "2024-07-03T15:28:02.825274+03:00",
  "status": "placed",
  "complete": false
}'
```
