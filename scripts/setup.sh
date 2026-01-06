#!/bin/bash


# Variables
RESOURCE_GROUP_NAME=my-resource-group
SA_NAME=tfbackendstate
CONTAINER_NAME=tfstate
LOCATION=swedencentral

# Create storage account for environment
az storage account create \
  --name $SA_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --location $LOCATION \
  --sku Standard_LRS \
  --kind StorageV2 \
  --encryption-services blob \
  --https-only true \
  --allow-blob-public-access false


# Create blob container for environment
az storage container create \
  --name $CONTAINER_NAME \
  --account-name $SA_NAME \
  --auth-mode login

