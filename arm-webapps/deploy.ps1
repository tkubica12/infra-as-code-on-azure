
$resourceGroupName = "arm-webapps"
$location = "westeurope"
New-AzureRmResourceGroup -Name $resourceGroupName -Location $location

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
    -TemplateFile webapps.json `
    -TemplateParameterFile webapps.parameters.json

