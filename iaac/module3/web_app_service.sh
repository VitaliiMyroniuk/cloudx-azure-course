#!/bin/bash

function create_app_service_plan() {
  local name="$1-$2"
  local location=$2

  echo "Going to create an App Service Plan: $name"

  az appservice plan create \
    --name $name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $location \
    --sku P0v3 \
    --is-linux \
    --output none

  echo "Created an App Service Plan: $name"
}

function create_web_app_service() {
  local name="$1-$3"
  local app_service_plan="$2-$3"
  local image_name=$1

  echo "Going to create a Web App Service: $name"

  az webapp create \
    --name $name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --plan $app_service_plan \
    --container-image-name "$CONTAINER_REGISTRY_SERVER/$image_name:latest" \
    --container-registry-user $CONTAINER_REGISTRY_USERNAME \
    --container-registry-password $CONTAINER_REGISTRY_PASSWORD \
    --output none

  echo "Created a Web App Service: $name"
}

function configure_env_variables() {
  local name="$1-$2"
  local settings=$3

  echo "Going to configure environment variables for a Web App Service: $name"

  az webapp config appsettings set \
    --name $name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings $settings \
    --output none

  echo "Configured environment variables for a Web App Service: $name"
}

function create_autoscale_monitor() {
  local name="$1-$3"
  local app_service_plan="$2-$3"

  echo "Going to create an autoscale monitor for a Web App Service: $name"

  az monitor autoscale create \
    --name $name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --resource $app_service_plan \
    --resource-type Microsoft.Web/serverfarms \
    --min-count 1 \
    --max-count 3 \
    --count 1 \
    --output none

  echo "Created an autoscale monitor for a Web App Service: $name"
}

function create_autoscale_rule() {
  local autoscale_name="$1-$2"
  local condition=$3
  local scale=$4

  echo "Going to create an autoscale rule for a Web App Service: $autoscale_name"

  az monitor autoscale rule create \
    --resource-group $RESOURCE_GROUP_TEMP \
    --autoscale-name $autoscale_name \
    --condition $condition \
    --scale $scale \
    --output none

  echo "Created an autoscale rule for a Web App Service: $name"
}

function create_deployment_slot() {
  local web_app_name="$1-$2"
  local slot_name=$3

  echo "Going to create a deplyment slot for a Web App Service: $web_app_name"

  az webapp deployment slot create \
    --name $web_app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --configuration-source $web_app_name \
    --slot $slot_name \
    --output none

  echo "Created a deplyment slot for a Web App Service: $web_app_name"
}

function enable_continuous_deployment() {
  local web_app_name="$1-$2"

  echo "Going to enable continuous deployment for a Web App Service: $web_app_name"

  az webapp deployment container config \
    --name $web_app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --enable-cd true \
    --output none

  echo "Enabled continuous deployment for a Web App Service: $web_app_name"
}

# Deploy the pet store application
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_app_service_plan $WEB_APP_SERVICE_PLAN $LOCATION_1
create_app_service_plan $WEB_APP_SERVICE_PLAN $LOCATION_2
create_app_service_plan $API_APP_SERVICE_PLAN $LOCATION_1

source ../common/05_login_container_registry.sh

create_web_app_service $WEB_APP $WEB_APP_SERVICE_PLAN $LOCATION_1
create_web_app_service $WEB_APP $WEB_APP_SERVICE_PLAN $LOCATION_2
create_web_app_service $PRODUCT_SERVICE $API_APP_SERVICE_PLAN $LOCATION_1
create_web_app_service $ORDER_SERVICE $API_APP_SERVICE_PLAN $LOCATION_1
create_web_app_service $PET_SERVICE $API_APP_SERVICE_PLAN $LOCATION_1

configure_env_variables $WEB_APP $LOCATION_1 "@web_app_env_vars.json"
configure_env_variables $WEB_APP $LOCATION_2 "@web_app_env_vars.json"
configure_env_variables $ORDER_SERVICE $LOCATION_1 "@order_svc_env_vars.json"

create_autoscale_monitor $WEB_APP $WEB_APP_SERVICE_PLAN $LOCATION_1

create_autoscale_rule $WEB_APP $LOCATION_1 "CpuPercentage > 70 avg 5m" "in 1"
create_autoscale_rule $WEB_APP $LOCATION_1 "CpuPercentage < 20 avg 5m" "out 1"

#create_deployment_slot $WEB_APP $LOCATION_1 "staging"

#enable_continuous_deployment $WEB_APP $LOCATION_1

echo "Deployment successfully completed"

