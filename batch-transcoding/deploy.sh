# Deploy Azure Batch and Pool
export resourceGroup=batch
export storageAccountName=mojebatchstorage1
export batchAccountName=mujbatch1

az group create -n $resourceGroup -l westeurope
az group deployment create -g $resourceGroup --template-file batch.json

# Get access information
export AZURE_BATCH_ENDPOINT=$(az batch account show -n $batchAccountName -g $resourceGroup --query accountEndpoint -o tsv)
export AZURE_BATCH_ACCESS_KEY=$(az batch account keys list -n $batchAccountName -g $resourceGroup --query primary -o tsv)
export AZURE_BATCH_ACCOUNT=$batchAccountName
export AZURE_STORAGE_ACCOUNT=$storageAccountName
export AZURE_STORAGE_ACCESS_KEY=$(az storage account keys list -n $storageAccountName -g $resourceGroup --query [0].value -o tsv)

# Create storage account, contaners and upload videos
az storage container create -n inputs
export inputsas=$(az storage container generate-sas -n inputs \
    --start 2018-01-01 \
    --expiry 2020-01-01 \
    --permissions r \
    -o tsv )
az storage container create -n outputs
export outputsas=$(az storage container generate-sas -n outputs \
    --start 2018-01-01 \
    --expiry 2020-01-01 \
    --permissions rwld \
    -o tsv )

for i in {0..20}
    do 
        az storage blob upload --container-name inputs --file video.mp4 --name video$i.mp4
    done

# Create Job and Tasks
az batch job create --id job --pool-id mypool

for i in {0..20}
    do 
        echo '
            {
            "id": "task'$i'",
            "commandLine": "/bin/bash -c \"ffmpeg -i ./video'$i'.mp4 -vcodec h264 -b:v 10485760 -strict -2 video'$i'.transcoded.mp4\"",
            "resourceFiles": [
                {
                    "blobSource": "https://mojebatchstorage1.blob.core.windows.net/inputs/video'$i'.mp4?'$inputsas'",
                    "filePath": "video'$i'.mp4"
                }
            ],
            "outputFiles": [
                {
                    "destination": {
                        "container": {
                            "containerUrl": "https://mojebatchstorage1.blob.core.windows.net/outputs?'$outputsas'"
                        }
                        },
                    "filePattern": "*transcoded*",
                    "uploadOptions": {
                        "uploadCondition": "tasksuccess"
                    }
                }
            ]
            }
            ' > task.json
        az batch task create --job-id job --json-file task.json
        rm task.json
    done

# Destroy resource group
az group delete -n $resourceGroup -y --no-wait
