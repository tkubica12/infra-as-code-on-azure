# Create Resource Group
$resourceGroupName = "arm-language-rg"
New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

# Deploy simple template with parameters and variables, use parameters file, override one parameter in PowerShell
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile inputs.json `
-TemplateParameterFile inputs.parameters.json `
-ipName mojeip

# Construct URL with assigned static public IP address
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile outputs.json `
-ipName mojeip2

# Deterministic unique (idempotent)
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile deterministicUnique.json

# Loop
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile loop.json `
-ipNamePrefix mojeip4 `
-count 5

# Object input
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile objectInput.json `
-TemplateParameterFile objectInput.parameters.json 

# Nested template deploying to different resource group
$nestedGroupName = "arm-language-nested-rg"
New-AzureRmResourceGroup -ResourceGroupName $nestedGroupName `
-Location westeurope

New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile nested.json `
-nestedGroupName $nestedGroupName

# Nested linked template with loop
## Create storage account and copy linked template over
$storageAccountName = "mujrepozitarsablon"
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $resourceGroupName `
  -Name $storageAccountName `
  -Location westeurope `
  -SkuName Standard_LRS `
  | New-AzureStorageContainer -Name "templates" -Permission blob

$ctx = $storageAccount.Context
Set-AzureStorageBlobContent -Blob linked.json `
    -Container templates `
    -File .\linked.json `
    -Context $ctx `
    -Force

## Deploy main template
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile main.json

# Remove all resources
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob
Remove-AzureRmResourceGroup -Name $nestedGroupName -Force -AsJob