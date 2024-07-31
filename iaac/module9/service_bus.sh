#!/bin/bash

function create_service_bus_namespace() {
  echo "Going to create a Service Bus Namespace: $SERVICE_BUS_NAMESPACE"

  az servicebus namespace create \
    --name $SERVICE_BUS_NAMESPACE \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $LOCATION_1 \
    --sku Basic \
    --output none

  echo "Created a Service Bus Namespace: $SERVICE_BUS_NAMESPACE"
}

function create_service_bus_queue() {
  echo "Going to create a Service Bus Queue: $SERVICE_BUS_QUEUE"

  az servicebus queue create \
    --name $SERVICE_BUS_QUEUE \
    --namespace-name $SERVICE_BUS_NAMESPACE \
    --resource-group $RESOURCE_GROUP_TEMP \
    --max-delivery-count 3 \
    --output none

  echo "Created a Service Bus Queue: $SERVICE_BUS_QUEUE"
}

# Deploy Service Bus
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_service_bus_namespace
create_service_bus_queue

echo "Deployment successfully completed"

