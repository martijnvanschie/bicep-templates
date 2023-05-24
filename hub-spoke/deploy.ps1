[string] $subscription = ''
[string] $resourceGroup = ''
[string] $deploymentName = 'HubSpoke.Test'

az account set --subscription $subscription
az deployment group create -c -g $resourceGroup -f .\main.bicep -n $deploymentName