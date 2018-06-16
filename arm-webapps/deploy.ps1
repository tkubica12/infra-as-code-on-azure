# Create Resource Group
$resourceGroupName = "arm-webapps"
$location = "westeurope"
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

# Deploy SaaS apps
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
    -TemplateFile webapps.json `
    -TemplateParameterFile webapps.parameters.json

# Remove all resources
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob
