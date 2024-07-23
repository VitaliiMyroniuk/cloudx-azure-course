#!/bin/bash

function create_key_vault() {
  echo "Going to create Key Vault: $KEY_VAULT"

  az keyvault create \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $LOCATION_1 \
    --name $KEY_VAULT \
    --enable-rbac-authorization false \
    --output none

  echo "Created Key Vault: $KEY_VAULT"
}

function add_secret_to_key_vault() {
  local name=$1
  local value=$2

  echo "Going to add secret '$name' to Key Vault: $KEY_VAULT"

  az keyvault secret set \
    --vault-name $KEY_VAULT \
    --name $name \
    --value $value \
    --output none

  echo "Added secret '$name' to Key Vault: $KEY_VAULT"
}

function set_key_vault_policy() {
  local objectID=$1

  echo "Going to set policy to Key Vault: $KEY_VAULT"

  az keyvault set-policy \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $KEY_VAULT \
    --object-id $objectID \
    --secret-permissions get list \
    --output none

  echo "Set policy to Key Vault: $KEY_VAULT"
}

function add_sectrets_to_container_app() {
  local app_name=$1
  local secrets=$2

  echo "Going to add secrets to a Container App: $app_name"

  az containerapp secret set \
    --name $app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --secrets $secrets \
    --output none

  echo "Added secrets to a Container App: $app_name"
}

function add_env_vars_to_container_app() {
  local app_name=$1
  local env_vars=$2

  echo "Going to add environment variables to a Container App: $app_name"

  az containerapp update \
    --name $app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --set-env-vars $env_vars \
    --output none

  echo "Added environment variables to a Container App: $app_name"
}

# Deploy Key Vault
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_key_vault

add_secret_to_key_vault postgres-user $POSTGRES_USER
add_secret_to_key_vault postgres-password $POSTGRES_PASSWORD
add_secret_to_key_vault cosmos-db-key $(az cosmosdb keys list -n $COSMOS_DB_ACCOUNT -g $RESOURCE_GROUP_TEMP --query primaryMasterKey --output tsv)

set_key_vault_policy $(az containerapp identity show -n $PET_SERVICE-$LOCATION_1 -g $RESOURCE_GROUP_TEMP --query principalId --output tsv)
set_key_vault_policy $(az containerapp identity show -n $PRODUCT_SERVICE-$LOCATION_1 -g $RESOURCE_GROUP_TEMP --query principalId --output tsv)
set_key_vault_policy $(az containerapp identity show -n $ORDER_SERVICE-$LOCATION_1 -g $RESOURCE_GROUP_TEMP --query principalId --output tsv)

add_sectrets_to_container_app "$PET_SERVICE-$LOCATION_1" "
 postgres-user=keyvaultref:$KEY_VAULT_POSTGRES_USER_SECRET_URI,identityref:system 
 postgres-password=keyvaultref:$KEY_VAULT_POSTGRES_PASSWORD_SECRET_URI,identityref:system"

add_sectrets_to_container_app "$PRODUCT_SERVICE-$LOCATION_1" "
 postgres-user=keyvaultref:$KEY_VAULT_POSTGRES_USER_SECRET_URI,identityref:system 
 postgres-password=keyvaultref:$KEY_VAULT_POSTGRES_PASSWORD_SECRET_URI,identityref:system"

add_sectrets_to_container_app "$ORDER_SERVICE-$LOCATION_1" "
 cosmos-db-key=keyvaultref:$KEY_VAULT_COSMOS_DB_KEY_SECRET_URI,identityref:system"

add_env_vars_to_container_app "$PET_SERVICE-$LOCATION_1" "
 POSTGRES_USER=secretref:postgres-user 
 POSTGRES_PASSWORD=secretref:postgres-password"

add_env_vars_to_container_app "$PRODUCT_SERVICE-$LOCATION_1" "
 POSTGRES_USER=secretref:postgres-user 
 POSTGRES_PASSWORD=secretref:postgres-password"

add_env_vars_to_container_app "$ORDER_SERVICE-$LOCATION_1" "
 COSMOS_DB_KEY=secretref:cosmos-db-key"

echo "Deployment successfully completed"
