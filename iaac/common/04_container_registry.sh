#!/bin/bash

source ../common/01_setup_env_vars.sh

function create_container_registry() {
  echo "Going to created a Container Registry: $CONTAINER_REGISTRY"

  az acr create \
    --name $CONTAINER_REGISTRY \
    --resource-group $RESOURCE_GROUP_PERM \
    --sku Basic \
    --admin-enabled true \
    --output none

  echo "Created a Container Registry: $CONTAINER_REGISTRY"
}

create_container_registry

