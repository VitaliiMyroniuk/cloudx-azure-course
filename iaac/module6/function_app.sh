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

function link_function_app_with_service() {
  local app_name="$1-$2"
  local env_vars=$3

  echo "Going to link a Function App with a Container App: $app_name"

  az containerapp update \
    --name $app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --set-env-vars $env_vars \
    --output none

  echo "Linked a Function App with a Container App: $app_name"
}

# Deploy Function App
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_function_app
enable_system_assigned_managed_identity
sleep 30s
assign_blob_storage_contributor_role
link_function_app_with_service $ORDER_SERVICE $LOCATION_1 "PETSTORE_ORDER_ITEMS_RESERVER_URL=https://$FUNCTION_APP.azurewebsites.net"

echo "Deployment successfully completed"

