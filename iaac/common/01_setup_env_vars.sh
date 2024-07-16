#!/bin/bash

# Common
RESOURCE_GROUP_PERM="petstore-perm"
RESOURCE_GROUP_TEMP="petstore-temp"
LOCATION_1="eastus"
LOCATION_2="westeurope"
LOCATION_3="westus"
WEB_APP="petstore-web-app"
PRODUCT_SERVICE="petstore-product-svc"
ORDER_SERVICE="petstore-order-svc"
PET_SERVICE="petstore-pet-svc"

# Container Registry
CONTAINER_REGISTRY_SERVER="petstore.azurecr.io"
CONTAINER_REGISTRY="petstore"
CONTAINER_REGISTRY_USERNAME="petstore"
CONTAINER_REGISTRY_PASSWORD="<to_be_added>"

# Web App Service
WEB_APP_SERVICE_PLAN="petstore-web"
API_APP_SERVICE_PLAN="petstore-api"

# Traffic Manager
TRAFFIC_MANAGER_PROFILE="petstore-web-app"

# Container App Service
CONTAINER_APP_ENV="petstore-app-env"

# App Insights
APP_INSIGHTS="petstore-app-insights"
APP_INSIGHTS_CONNECTION_STRING="<to_be_added>"

# Blob Storage
BLOB_STORAGE_ACCOUNT="petstorestorage"
BLOB_STORAGE_ORDERS_CONTAINER="orders"
BLOB_STORAGE_DATA_CONTRIBUTOR_ROLE="Storage Blob Data Contributor"

# Function App
FUNCTION_APP="petstore-order-items-reserver"

# PostgreSQL
POSTGRES_SERVER="petstore-server"
POSTGRES_DB="petstore_db"
POSTGRES_USER="vitalii"
POSTGRES_PASSWORD="<to_be_added>"

#Cosmos DB
COSMOS_DB_ACCOUNT="petstore-account"
COSMOS_DB_DATABASE="petstore_db"
