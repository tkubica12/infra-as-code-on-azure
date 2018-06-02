$resourceGroupName = "automation-dsc"

New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

$storageAccountName = "mojedscsoubory"
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location westeurope `
  -SkuName Standard_LRS `
  | New-AzureStorageContainer -Name "dsc" -Permission blob

$ctx = $storageAccount.Context
Set-AzureStorageBlobContent -Blob WindowsIISServerConfig.ps1 `
    -Container dsc `
    -File .\WindowsIISServerConfig.ps1 `
    -Context $ctx `
    -Force


New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile auto.json `
-TemplateParameterFile auto.parameters.json

Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob