export resourceGroup=cloudinitdemo
az group create -n $resourceGroup -l westeurope
az vm create -n jumpserver -g $resourceGroup \
    --admin-username tomas \
    --authentication-type password \
    --admin-password Azure12345678 \
    --image UbuntuLTS \
    --nsg "" \
    --size Standard_B1ms \
    --custom-data ./cloud-init.yaml \
    --storage-sku Premium_LRS
