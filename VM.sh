#!/bin/bash
##### RG and VNet #################
#az account set --subscription <your subscription GUID>
az group create -l eastus -n Prasad
az network vnet create -g Prasad -n Prasad-FirstVnet1 --address-prefix 10.2.0.0/16 
az network vnet subnet create --name Prasad-Sub1 --vnet-name Prasad-FirstVnet1 --resource-group Prasad  --address-prefixes 10.2.1.0/24

##### NSG & Rule availability set#############
az network nsg create -g Prasad -n Prasad_NSG1
az network nsg rule create -g Prasad --nsg-name Prasad_NSG1 -n Prasad_NSG1_Rule1 --priority 100 \
--source-address-prefixes '*' --source-port-ranges '*'     --destination-address-prefixes '*' \
--destination-port-ranges '*' --access Allow   --protocol Tcp --description "Allow from specific IP range" 
az vm availability-set	create --name EAST-AVSET1 -g Prasad --location eastus

######### Create a VM ################

az vm create --resource-group Prasad --name PrasadVM --image UbuntuLTS --vnet-name Prasad-FirstVnet1 \
--subnet Prasad-Sub1 --admin-username kiran --admin-password "Kiran1234!@#" --size Standard_B1s \
--availability-set EAST-AVSET1 --nsg Prasad_NSG1


############ Deleting A RG #################

#az group delete -n <Name of RG> --yes