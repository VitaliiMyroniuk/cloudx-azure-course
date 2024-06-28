#!/bin/bash

source ../common/01_setup_env_vars.sh

function login_acr() {
  echo "Going to login the Container Registry: $CONTAINER_REGISTRY"

  az acr login \
    --name $CONTAINER_REGISTRY \
    --output none

  CONTAINER_REGISTRY_PASSWORD="$(az acr credential show -n $CONTAINER_REGISTRY -g $RESOURCE_GROUP_PERM --query 'passwords[0].value' --output tsv)"
}

login_acr

