#!/bin/bash

function create_traffic_manager_profile() {
  echo "Going to create a Traffic Manager Profile: $TRAFFIC_MANAGER_PROFILE"

  az network traffic-manager profile create \
    --name $TRAFFIC_MANAGER_PROFILE \
    --resource-group $RESOURCE_GROUP_TEMP \
    --routing-method Priority \
    --path '/' \
    --protocol "HTTPS" \
    --unique-dns-name $TRAFFIC_MANAGER_PROFILE  \
    --ttl 30 \
    --port 80 \
    --output none

  echo "Created a Traffic Manager Profile: $TRAFFIC_MANAGER_PROFILE"
}

function create_traffic_manager_endpoint() {
  local web_app_name="$1-$2"
  local target_resource_id=$(az webapp show --name $web_app_name --resource-group $RESOURCE_GROUP_TEMP --query id --output tsv)
  local priority=$3

  echo "Going to create a Traffic Manager Endpoint: $web_app_name"

  az network traffic-manager endpoint create \
    --name "$web_app_name" \
    --resource-group $RESOURCE_GROUP_TEMP \
    --profile-name $TRAFFIC_MANAGER_PROFILE \
    --type azureEndpoints \
    --target-resource-id $target_resource_id \
    --priority $priority \
    --endpoint-status Enabled \
    --output none

  echo "Created a Traffic Manager Endpoint: $web_app_name"
}


# Deploy the traffic manager for the pet store web application
echo "Start deployment..."

create_traffic_manager_profile
create_traffic_manager_endpoint $WEB_APP $LOCATION_1 1
create_traffic_manager_endpoint $WEB_APP $LOCATION_2 2

echo "Deployment successfully completed"

