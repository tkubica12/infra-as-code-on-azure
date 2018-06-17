# Create Resource Group
$resourceGroupName = "arm-db-aci-rg"
New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

# Deploy Azure Database for PostgreSQL and ACI container with script to move data
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile postgresqlWithData.json

# Destroy resource group
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob