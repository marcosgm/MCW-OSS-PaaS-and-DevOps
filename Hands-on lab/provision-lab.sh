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
SUBSCRIPTION=0208f208-847e-4ce3-ade5-7349ad21eb72
parametersFilePath="lab-files/JenkinsVM/parameters.json"
templateFilePath="lab-files/JenkinsVM/template.json"
az group create -n $JENKINSRGNAME -l $LOCATION
az group deployment create --name "$DEPLOYMENTNAME" --resource-group "$JENKINSRGNAME" \
  --template-file "$templateFilePath" --parameters "@${parametersFilePath}" \
  --parameters dnsPrefix="$DNSPREFIX"  location="$LOCATION" adminPassword="$JENKINSPASS" --mode incremental  --no-wait