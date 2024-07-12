#!/bin/bash

function create_postgres_flexible_server() {
  echo "Going to create a PostgreSQL Flexible Server: $POSTGRES_SERVER"

  az postgres flexible-server create \
    --name $POSTGRES_SERVER \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $LOCATION_3 \
    --database-name $POSTGRES_DB \
    --admin-user $POSTGRES_USER \
    --admin-password $POSTGRES_PASSWORD \
    --public-access All \
    --version 16 \
    --sku-name Standard_B1ms \
    --tier Burstable \
    --backup-retention 7 \
    --output none

  echo "Created a PostgreSQL Flexible Server: $POSTGRES_SERVER"
}

# Deploy PostgreSQL
echo "Start deployment..."

source ../common/03_temp_resource_group.sh create

create_postgres_flexible_server

echo "Deployment successfully completed"

