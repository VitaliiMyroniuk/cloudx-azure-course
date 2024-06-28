#!/bin/bash

source ../common/01_setup_env_vars.sh

function create_resource_group() {
  echo "Going to create an Azure Resource Group: $RESOURCE_GROUP_TEMP"

  az group create \
    --name $RESOURCE_GROUP_TEMP \
    --location $LOCATION_1 \
    --output none

  echo "Created an Azure Resource Group: $RESOURCE_GROUP_TEMP"
}

function delete_resource_group() {
  echo "Going to delete an Azure Resource Group: $RESOURCE_GROUP_TEMP"

  az group delete \
    --name $RESOURCE_GROUP_TEMP \
    --yes \
    --output none

  echo "Deleted an Azure Resource Group: $RESOURCE_GROUP_TEMP"
}

if [ $1 = "create" ]
  then
    create_resource_group
elif [ $1 = "delete" ]
  then
    delete_resource_group
else
  echo "Required operation parameter is missed: [create, delete]"
fi

