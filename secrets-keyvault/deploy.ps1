# Create Resource Group
$resourceGroupName = "secrets-demo-rg"
New-AzureRmResourceGroup -ResourceGroupName $resourceGroupName `
-Location westeurope

# Create Azure Key Vault
$keyVaultName = "my-keyvault-123"
$keyVault = New-AzureRmKeyVault -VaultName $keyVaultName `
    -ResourceGroupName $resourceGroupName `
    -EnabledForTemplateDeployment `
    -Location westeurope

$secretvalue = ConvertTo-SecureString 'mojeHeslo1234@' -AsPlainText -Force
Set-AzureKeyVaultSecret -VaultName $keyVaultName  `
    -Name 'moje-heslo' -SecretValue $secretvalue

# Get Key Vault ID for rederence in parameters
$keyVault.ResourceID

# Deploy VM and DB with secrets via Key Vault (no password visible for operator)
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile secrets.json `
-TemplateParameterFile secrets.parameters.json

# Grant VM identity to retrieve password from key Vault
$principalId = (Get-AzureRmVM -Name myvm -ResourceGroupName $resourceGroupName).Identity.PrincipalId
Set-AzureRmKeyVaultAccessPolicy -VaultName $keyVaultName `
    -ObjectId $principalId `
    -PermissionsToSecrets Get

# SSH to VM and use MSI endpoint to get token to talk to Azure
sudo apt install jq -y
curl "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net" \
    -H "Metadata: true"
    
export token=$(curl -s "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net" \
    -H "Metadata: true" \
    | jq -r .access_token)

# Use this token to retrieve password from Key Vault

curl -s https://my-keyvault-123.vault.azure.net/secrets/moje-heslo?api-version=2016-10-01 -H "Authorization: Bearer $token"

sudo apt install mysql-client -y

mysql -hmoje-mysql-db.mysql.database.azure.com \
    -udbadmin@moje-mysql-db \
    -p$(curl -s https://my-keyvault-123.vault.azure.net/secrets/moje-heslo?api-version=2016-10-01 -H "Authorization: Bearer $token" | jq -r .value) \
    -e "SHOW DATABASES;"

# Remove resource group
Remove-AzureRmResourceGroup -Name $resourceGroupName -Force -AsJob