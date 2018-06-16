# Create Resource Group
$resourceGroupName = "extension-dsc-iis"
New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

# Prepare storage account and container
$storageAccountName = "mujextensionstorage"
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location westeurope `
  -SkuName Standard_LRS `
  | New-AzureStorageContainer -Name "windows-powershell-dsc" -Permission blob

# Compile, package and push DSC to storage
Publish-AzureRmVMDscConfiguration -ResourceGroupName $resourceGroupName `
  -StorageAccountName $storageAccountName `
  -ConfigurationPath .\setupIIS.ps1 `
  -Force

# Deploy resources
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile vm.json `
-TemplateParameterFile vm.parameters.json

# Destroy resource group
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob