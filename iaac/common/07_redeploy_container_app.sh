#!/bin/bash

source ../common/01_setup_env_vars.sh
source ../common/05_login_container_registry.sh

function redeploy_container_app() {
  local app_name=$1
  local image_name=${1%-*}
  local version="${2:-latest}"

  echo "Going to redeploy a Container App '$app_name' with the '$version' version"

  az containerapp update \
    --name $app_name \
    --resource-group $RESOURCE_GROUP_TEMP \
    --image "$CONTAINER_REGISTRY_SERVER/$image_name:$version" \
    --output none

  echo "Redeployed a Container App '$app_name' with the '$version' version"
}

redeploy_container_app $1 $2

