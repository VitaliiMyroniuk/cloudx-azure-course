#!/bin/bash

function create_container_app_environment() {
  local name="$1-$2"
  local location=$2

  echo "Going to create a Container App Environment: $name"

  az containerapp env create \
    --name $name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $location \
    --enable-workload-profiles false \
    --logs-destination none \
    --output none

  echo "Created a Container App Environment: $name"
}

function create_container_app() {
  local name="$1-$3"
  local container_app_env="$2-$3"
  local image_name=$1

  echo "Going to create a Container App: $name"

  az containerapp create \
    --name $name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --environment $container_app_env \
    --registry-server $CONTAINER_REGISTRY_SERVER \
    --registry-username $CONTAINER_REGISTRY_USERNAME \
    --registry-password $CONTAINER_REGISTRY_PASSWORD \
    --image "$CONTAINER_REGISTRY_SERVER/$image_name:latest" \
    --cpu 0.25 \
    --memory 0.5Gi \
    --min-replicas 1 \
    --max-replicas 3 \
    --scale-rule-name $name \
    --scale-rule-type http \
    --scale-rule-http-concurrency 10 \
    --output none

    echo "Created a Container App: $name"
}

function configure_ingress_settings() {
    local app_name="$1-$2"

    echo "Going to configure ingress settings for a Container App: $app_name"

    az containerapp ingress enable \
    --name $app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --target-port 8080 \
    --transport auto \
    --type external \
    --allow-insecure \
    --output none

    echo "Configured ingress settings for a Container App: $app_name"
}

function configure_environment_variables() {
  local app_name="$1-$2"
  local env_vars=$3

  echo "Going to configure environment variables for a Container App: $app_name"

  az containerapp update \
    --name $app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --set-env-vars $env_vars \
    --output none

  echo "Configured environment variables for a Container App: $app_name"
}

function configure_multiple_revision_mode() {
  local app_name="$1-$2"

  echo "Going to configure a multiple revision mode for a Container App: $app_name"

  az containerapp revision set-mode \
    --name $app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --mode multiple \
    --output none

  echo "Configured a multiple revision mode for a Container App: $app_name"
}

# Deploy the pet store application
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_container_app_environment $CONTAINER_APP_ENV $LOCATION_1

source ../common/05_login_container_registry.sh

create_container_app $WEB_APP $CONTAINER_APP_ENV $LOCATION_1
create_container_app $PRODUCT_SERVICE $CONTAINER_APP_ENV $LOCATION_1
create_container_app $ORDER_SERVICE $CONTAINER_APP_ENV $LOCATION_1
create_container_app $PET_SERVICE $CONTAINER_APP_ENV $LOCATION_1

configure_ingress_settings $WEB_APP $LOCATION_1
configure_ingress_settings $PRODUCT_SERVICE $LOCATION_1
configure_ingress_settings $ORDER_SERVICE $LOCATION_1
configure_ingress_settings $PET_SERVICE $LOCATION_1

configure_environment_variables $WEB_APP $LOCATION_1 "
 PETSTOREPETSERVICE_URL=https://$(az containerapp show -n petstore-pet-svc-$LOCATION_1 -g $RESOURCE_GROUP_TEMP --query 'properties.configuration.ingress.fqdn' --output tsv) 
 PETSTOREPRODUCTSERVICE_URL=https://$(az containerapp show -n petstore-product-svc-$LOCATION_1 -g $RESOURCE_GROUP_TEMP --query 'properties.configuration.ingress.fqdn' --output tsv) 
 PETSTOREORDERSERVICE_URL=https://$(az containerapp show -n petstore-order-svc-$LOCATION_1 -g $RESOURCE_GROUP_TEMP --query 'properties.configuration.ingress.fqdn' --output tsv)"

configure_environment_variables $PRODUCT_SERVICE $LOCATION_1 "
 POSTGRES_USER=$POSTGRES_USER 
 POSTGRES_PASSWORD=$POSTGRES_PASSWORD"

configure_environment_variables $ORDER_SERVICE $LOCATION_1 "
 PETSTOREPRODUCTSERVICE_URL=https://$(az containerapp show -n petstore-product-svc-$LOCATION_1 -g $RESOURCE_GROUP_TEMP --query 'properties.configuration.ingress.fqdn' --output tsv) 
 COSMOS_DB_KEY=$(az cosmosdb keys list -n $COSMOS_DB_ACCOUNT -g $RESOURCE_GROUP_TEMP --query primaryMasterKey --output tsv)"

configure_environment_variables $PET_SERVICE $LOCATION_1 "
 POSTGRES_USER=$POSTGRES_USER 
 POSTGRES_PASSWORD=$POSTGRES_PASSWORD"

#configure_multiple_revision_mode $WEB_APP $LOCATION_1
#configure_multiple_revision_mode $PRODUCT_SERVICE $LOCATION_1
#configure_multiple_revision_mode $ORDER_SERVICE $LOCATION_1
#configure_multiple_revision_mode $PET_SERVICE $LOCATION_1

echo "Deployment successfully completed"

