#!/bin/bash

source ../common/01_setup_env_vars.sh
source ../common/05_login_container_registry.sh

function build_and_push_image() {
  local source_location=$1
  local image_name=$2
  local version="${3:-latest}"

  echo "Going to build and push an image: $image_name:$version"

  az acr build \
    --registry $CONTAINER_REGISTRY \
    --image $image_name:$version \
    --resource-group $RESOURCE_GROUP_PERM \
    $source_location

  echo "Built and pushed an image: $image_name:$version"
}

if [ $1 = $WEB_APP ]
  then
    build_and_push_image "../../petstoreapp" $1 $2
elif [ $1 = $PRODUCT_SERVICE ]
  then
    build_and_push_image "../../petstoreproductservice" $1 $2
elif [ $1 = $ORDER_SERVICE ]
  then
    build_and_push_image "../../petstoreorderservice" $1 $2
elif [ $1 = $PET_SERVICE ]
  then
    build_and_push_image "../../petstorepetservice" $1 $2
else
  echo "Required service name is missed: [$WEB_APP, $PRODUCT_SERVICE, $ORDER_SERVICE, $PET_SERVICE]"
fi

