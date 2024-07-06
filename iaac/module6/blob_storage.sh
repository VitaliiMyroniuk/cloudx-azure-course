#!/bin/bash

function create_storage_account() {
  echo "Going to create a Blob Storage Account: $BLOB_STORAGE_ACCOUNT"

  az storage account create \
    --name $BLOB_STORAGE_ACCOUNT \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $LOCATION_1 \
    --kind StorageV2 \
    --min-tls-version TLS1_2 \
    --output none

  echo "Created a Blob Storage Account: $BLOB_STORAGE_ACCOUNT"
}

function create_storage_container() {
  echo "Going to create a Blob Storage Container: $BLOB_STORAGE_ORDERS_CONTAINER"

  az storage container create \
    --name $BLOB_STORAGE_ORDERS_CONTAINER \
    --account-name $BLOB_STORAGE_ACCOUNT \
    --output none

  echo "Created a Blob Storage Container: $BLOB_STORAGE_ORDERS_CONTAINER"
}

# Deploy Blob Storage
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_storage_account
create_storage_container

echo "Deployment successfully completed"

