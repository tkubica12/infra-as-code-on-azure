# Create Resource Group
$resourceGroupName = "arm-iaas-rg"
New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile networking.json `
-TemplateParameterFile networking.parameters.json

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile vms.json `
-TemplateParameterFile vms.parameters.json

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile vms.json `
-TemplateParameterFile vms.parameters.json `
-backendCount 3 `
-frontendCount 3

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile vms.json `
-TemplateParameterFile vms.parameters.json `
-Mode Complete

Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob