$resourceGroupName = "extension-dsc-iis"

New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

$storageAccountName = "mujextensionstorage"
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location westeurope `
  -SkuName Standard_LRS `
  | New-AzureStorageContainer -Name "windows-powershell-dsc" -Permission blob

Publish-AzureRmVMDscConfiguration -ResourceGroupName $resourceGroupName `
  -StorageAccountName $storageAccountName `
  -ConfigurationPath .\setupIIS.ps1 `
  -Force

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile vm.json `
-TemplateParameterFile vm.parameters.json

Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob