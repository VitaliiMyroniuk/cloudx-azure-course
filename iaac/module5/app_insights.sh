#!/bin/bash

function create_app_insights() {
  local name="$1-$2"
  local location=$2

  echo "Going to create App Insights: $name"

  az monitor app-insights component create \
    --app $name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $location \
    --output none

  echo "Created App Insights: $name"
}

function enable_app_insights_for_service() {
  local app_name="$1-$2"
  local env_vars=$3

  echo "Going to enable App Insights for a Container App: $app_name"

  az containerapp update \
    --name $app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --set-env-vars $env_vars \
    --output none

  echo "Enabled App Insights for a Container App: $app_name"
}

# Deploy App Insights for the pet store application
echo "Start deployment..."

source ../common/01_setup_env_vars.sh

create_app_insights $APP_INSIGHTS $LOCATION_1

APP_INSIGHTS_CONNECTION_STRING=$(az monitor app-insights component show --app $APP_INSIGHTS-$LOCATION_1 -g $RESOURCE_GROUP_TEMP --query 'connectionString' --output tsv)

enable_app_insights_for_service $WEB_APP $LOCATION_1 "APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING"
enable_app_insights_for_service $PRODUCT_SERVICE $LOCATION_1 "APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING"
enable_app_insights_for_service $ORDER_SERVICE $LOCATION_1 "APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING"
enable_app_insights_for_service $PET_SERVICE $LOCATION_1 "APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING"

echo "Deployment successfully completed"

