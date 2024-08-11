#!/bin/bash

echo "Start deployment..."

source ../common/01_setup_env_vars.sh
source ../common/02_perm_resource_group.sh create
source ../common/03_temp_resource_group.sh create
source ../common/04_container_registry.sh
source ../common/05_login_container_registry.sh
source ../common/06_build_and_push_image.sh petstore-web-app
source ../common/06_build_and_push_image.sh petstore-pet-svc
source ../common/06_build_and_push_image.sh petstore-product-svc
source ../common/06_build_and_push_image.sh petstore-order-svc
source ../module7/postgres_db.sh
source ../module7/cosmos_db.sh
source ../module6/blob_storage.sh
source ../module9/service_bus.sh
source ../module6/function_app.sh
source ../module4/container_app_service.sh
source ../module8/key_vault.sh
source ../module5/app_insights.sh

echo "Deployment successfully completed"

