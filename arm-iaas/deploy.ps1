# Create Resource Group
$resourceGroupName = "arm-iaas-rg"
New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

# Deploy networking resources
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile networking.json `
-TemplateParameterFile networking.parameters.json

# Deploy VMs
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile vms.json `
-TemplateParameterFile vms.parameters.json

# Modify resources (scale up)
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile vms.json `
-TemplateParameterFile vms.parameters.json `
-backendCount 3 `
-frontendCount 3

# Modify resources (scale down - use Mode Complete)
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile vms.json `
-TemplateParameterFile vms.parameters.json `
-Mode Complete

# Destroy resource group
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob