# Create Resource Group
$resourceGroupName = "extension-joindomain"
New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

# Prepare storage account and container
$storageAccountName = "mujextensionstordomain"
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location westeurope `
  -SkuName Standard_LRS `
  | New-AzureStorageContainer -Name "windows-powershell-dsc" -Permission blob

# Compile, package and push DSC to storage
Publish-AzureRmVMDscConfiguration -ResourceGroupName $resourceGroupName `
  -StorageAccountName $storageAccountName `
  -ConfigurationPath .\setupAD.ps1 `
  -Force

# Deploy VM and configure Domain Controller
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile dc.json `
-TemplateParameterFile dc.parameters.json

# Deploy VM and join it to domain
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile joinedvm.json `
-TemplateParameterFile joinedvm.parameters.json

# Destroy resource group
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob