export resourceGroup=batch
export storageAccountName=mojebatchstorage1
export batchAccountName=mujbatch1

az group create -n $resourceGroup -l westeurope
az group deployment create -g $resourceGroup --template-file batch.json

export AZURE_BATCH_ENDPOINT=$(az batch account show -n $batchAccountName -g $resourceGroup --query accountEndpoint -o tsv)
export AZURE_BATCH_ACCESS_KEY=$(az batch account keys list -n $batchAccountName -g $resourceGroup --query primary -o tsv)
export AZURE_BATCH_ACCOUNT=$batchAccountName
export AZURE_STORAGE_ACCOUNT=$storageAccountName
export AZURE_STORAGE_ACCESS_KEY=$(az storage account keys list -n $storageAccountName -g $resourceGroup --query [0].value -o tsv)

az storage container create -n inputs
az storage container create -n outputs
az storage blob upload --container-name inputs --file video.mp4 --name video.mp4

for i in {0..20}
    do 
        az storage blob upload --container-name inputs --file video.mp4 --name video$i.mp4
    done

az batch job create --id job --pool-id mypool

az batch task create --job-id job --json-file task.json
