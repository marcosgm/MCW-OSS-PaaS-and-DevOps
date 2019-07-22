LOCATION=canadacentral
RGNAME=osspaasdevopslab-rg
#LABVMURI=https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoft%2FMCW-OSS-PaaS-and-DevOps%2Fmaster%2FHands-on%20lab%2Flab-files%2FLabVM%2Fazure-deploy.json
LABVMFILE=lab-files/LabVM/azure-deploy.json
LABVMUSER=demouser
LABVMPASS="$uperPassWord.1##"

az group create -n $RGNAME -l $LOCATION
az group deployment create -n LabVM -g $RGNAME --template-file $LABVMFILE --mode incremental --no-wait

#must be a unique string
DNSPREFIX=jenkinsmagarcia213
#must be an empty resource group
JENKINSRGNAME=osspaasdevopsjenkins-rg
JENKINSPASS='Password.1!!'
DEPLOYMENTNAME=$JENKINSRGNAME
SUBID=############## REPLACE FOR YOUR SUBSCRIPTION ID #############
parametersFilePath="lab-files/JenkinsVM/parameters.json"
templateFilePath="lab-files/JenkinsVM/template.json"
az group create -n $JENKINSRGNAME -l $LOCATION
az group deployment create --name "$DEPLOYMENTNAME" --resource-group "$JENKINSRGNAME" \
  --template-file "$templateFilePath" --parameters "@${parametersFilePath}" \
  --parameters dnsPrefix="$DNSPREFIX"  location="$LOCATION" adminPassword="$JENKINSPASS" --mode incremental  --no-wait


#Ex 1 - LabVM (Done)
#Ex 2 - CosmosDB
SUFFIX=random123
az cosmosdb create -n best-for-you-db-$SUFFIX --kind MongoDB -g $RGNAME 

#Ex 3 - ACR
REGISTRY=bestforyouregistry$SUFFIX
az acr create -n $REGISTRY -g $RGNAME --sku Basic --admin-enabled true

#Ex 4 - App Service for containers
APPSVCNAME=best-for-you-app-$SUFFIX
az appservice plan create -n $APPSVCNAME -g $RGNAME --is-linux --sku P1V2
az webapp create -g $RGNAME -p $APPSVCNAME -n $APPSVCNAME --deployment-container-image-name $REGISTRY.azurecr.io/best-for-you-organics:latest

#Ex 5 - JenkinsVM + service principal
az ad sp create-for-rbac -n "best-for-you-app" --role contributor --scopes /subscriptions/$SUBID/resourceGroups/$RGNAME

#Ex 6 - Function app and Storage Queues
SACCNAME=bestforyou$SUFFIXsg
az storage account create -n $SACCNAME -g $RGNAME -l $LOCATION --sku Standard_LRS
az functionapp create -n bestforyouorders$SUFFIX -g $RGNAME  -s $SACCNAME -p $APPSVCNAME

#Ex 7 - SendGrid and Logic App - UNSUPPORTED IN AZ CLI

