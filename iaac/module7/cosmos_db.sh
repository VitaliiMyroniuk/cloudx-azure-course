#!/bin/bash

function create_cosmos_db_account() {
  echo "Going to create a Cosmos DB account: $COSMOS_DB_ACCOUNT"

  az cosmosdb create \
    --name $COSMOS_DB_ACCOUNT \
    --resource-group $RESOURCE_GROUP_TEMP \
    --locations regionName=$LOCATION_3 \
    --output none

  echo "Created a Cosmos DB account: $COSMOS_DB_ACCOUNT"
}

function create_cosmos_db_database() {
  echo "Going to create a Cosmos DB database: $COSMOS_DB_DATABASE"

  az cosmosdb sql database create \
    --account-name $COSMOS_DB_ACCOUNT \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $COSMOS_DB_DATABASE \
    --output none

  echo "Created a Cosmos DB database: $COSMOS_DB_DATABASE"
}

function create_cosmos_db_container() {
  local name=$1
  local partitionKeyPath=$2

  echo "Going to create a Cosmos DB container: $name"

  az cosmosdb sql container create \
    --account-name $COSMOS_DB_ACCOUNT \
    --resource-group $RESOURCE_GROUP_TEMP \
    --database-name $COSMOS_DB_DATABASE \
    --name $name \
    --partition-key-path $partitionKeyPath \
    --output none

  echo "Created a Cosmos DB container: $name"
}

# Deploy CosmosDB
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_cosmos_db_account
create_cosmos_db_database
create_cosmos_db_container "orders" "/email"

echo "Deployment successfully completed"

