$resourceGroupName = "extension-joindomain"

New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

$storageAccountName = "mujextensionstordomain"
New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location westeurope `
  -SkuName Standard_LRS `
  | New-AzureStorageContainer -Name "windows-powershell-dsc" -Permission blob

Publish-AzureRmVMDscConfiguration -ResourceGroupName $resourceGroupName `
  -StorageAccountName $storageAccountName `
  -ConfigurationPath .\setupAD.ps1 `
  -Force

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile dc.json `
-TemplateParameterFile dc.parameters.json

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile joinedvm.json `
-TemplateParameterFile joinedvm.parameters.json

Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob