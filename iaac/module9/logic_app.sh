#!/bin/bash

function create_logic_app_workflow() {
  echo "Going to create a Logic App Workflow: $LOGIC_APP_WORKFLOW"

  az logic workflow create \
    --name $LOGIC_APP_WORKFLOW \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $LOCATION_1 \
    --definition workflow_definition.json \
    --output none

  echo "Created a Logic App Workflow: $LOGIC_APP_WORKFLOW"
}

# Deploy Logic App
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_logic_app_workflow

echo "Deployment successfully completed"

