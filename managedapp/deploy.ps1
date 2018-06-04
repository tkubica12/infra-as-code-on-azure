# Create resource group to store service catalog
$resourceGroupName = "managedapps-demo"

New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

# Compress template and UI definition to zip file
Compress-Archive -Path createUiDefinition.json, mainTemplate.json `
-DestinationPath app.zip

# Create storage account for zip (needed just for app registration to Azure, you can use any URL)
$storageAccountName = "mujmanagedapptemplate"
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location westeurope `
  -SkuName Standard_LRS `
  | New-AzureStorageContainer -Name "templates" -Permission blob

$ctx = $storageAccount.Context
Set-AzureStorageBlobContent -Blob app.zip `
    -Container templates `
    -File .\app.zip `
    -Context $ctx `
    -Force

# We will assign management rights of deployed instances to Service Principal I have prepared before
$userId=(Get-AzureRmADServicePrincipal -SearchString managedServicesAdmin).Id.Guid

# Get role
$roleid=(Get-AzureRmRoleDefinition -Name Owner).Id

# Create the definition for a managed application
New-AzureRmManagedApplicationDefinition `
  -Name "MojeManagedAppka" `
  -Location "westeurope" `
  -ResourceGroupName $resourceGroupName `
  -LockLevel ReadOnly `
  -DisplayName "Moje managed aplikace" `
  -Description "Ukazka pouziti katalogu sluzeb" `
  -Authorization "${userId}:$roleId" `
  -PackageFileUri "https://mujmanagedapptemplate.blob.core.windows.net/templates/app.zip"

# Go to Azure portal and create managed app. After creation show IAM (access rights).

# On end of demo remove resources
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob