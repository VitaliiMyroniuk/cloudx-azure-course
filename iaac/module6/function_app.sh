#!/bin/bash

function create_function_app() {
  echo "Going to create a Function App: $FUNCTION_APP"

  local deployLogs=$(cd ../../orderitemsreserver && ./gradlew clean azureFunctionsDeploy)

  echo "Created a Function App: $FUNCTION_APP"
}

function enable_system_assigned_managed_identity() {
  echo "Going to assign an identity to a Function App: $FUNCTION_APP"

  az functionapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $FUNCTION_APP \
    --output none

  echo "Assigned an identity to a Function App: $FUNCTION_APP"
}

function assign_blob_storage_contributor_role() {
  local subscription=$(az account show --query id --output tsv)
  local assignee=$(az functionapp identity show --name $FUNCTION_APP --resource-group $RESOURCE_GROUP_TEMP --query principalId --output tsv)

  echo "Going to assign '$BLOB_STORAGE_DATA_CONTRIBUTOR_ROLE' role to a Function App: $FUNCTION_APP"

  az role assignment create \
    --role "$BLOB_STORAGE_DATA_CONTRIBUTOR_ROLE" \
    --assignee $assignee \
    --scope "/subscriptions/$subscription/resourceGroups/$RESOURCE_GROUP_TEMP/providers/Microsoft.Storage/storageAccounts/$BLOB_STORAGE_ACCOUNT/blobServices/default/containers/$BLOB_STORAGE_ORDERS_CONTAINER" \
    --output none

  echo "Assigned '$BLOB_STORAGE_DATA_CONTRIBUTOR_ROLE' role to a Function App: $FUNCTION_APP"
}

function assign_service_bus_data_owner_role() {
  local subscription=$(az account show --query id --output tsv)
  local assignee=$(az functionapp identity show --name $FUNCTION_APP --resource-group $RESOURCE_GROUP_TEMP --query principalId --output tsv)

  echo "Going to assign '$SERVICE_BUS_DATA_OWNER_ROLE' role to a Function App: $FUNCTION_APP"

  az role assignment create \
    --role "$SERVICE_BUS_DATA_OWNER_ROLE" \
    --assignee $assignee \
    --scope "/subscriptions/$subscription/resourceGroups/$RESOURCE_GROUP_TEMP/providers/Microsoft.ServiceBus/namespaces/$SERVICE_BUS_NAMESPACE/queues/$SERVICE_BUS_QUEUE" \
    --output none

  echo "Assigned '$SERVICE_BUS_DATA_OWNER_ROLE' role to a Function App: $FUNCTION_APP"
}

# Deploy Function App
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_function_app
enable_system_assigned_managed_identity
sleep 30s
assign_blob_storage_contributor_role
assign_service_bus_data_owner_role

echo "Deployment successfully completed"

