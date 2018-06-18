# Connect to one of VMs and gather metadata
export ip=$(az network public-ip show -n app-frontend-ip -g arm-iaas-rg --query ipAddress -o tsv)
ssh tomas@$ip -p 9000

sudo apt install jq -y
curl -H Metadata:true "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | jq

# Get scheduled events
curl -s -H Metadata:true "http://169.254.169.254/metadata/scheduledevents?api-version=2017-08-01" | jq

# Restart VM
az vm restart -g arm-iaas-rg -n app-frontend-vm-1 --no-wait

# See scheduled event in affected VM
curl -s -H Metadata:true "http://169.254.169.254/metadata/scheduledevents?api-version=2017-08-01" | jq

# See scheduled event in other VMs in Availability Set
ssh tomas@$ip -p 9001
sudo apt install jq -y
curl -s -H Metadata:true "http://169.254.169.254/metadata/scheduledevents?api-version=2017-08-01" | jq


# Signal readiness for reboot
export eventId=$(curl -s -H Metadata:true "http://169.254.169.254/metadata/scheduledevents?api-version=2017-08-01" | jq -r .Events[0].EventId)
curl -H Metadata:true -X --data '{"StartRequests": [{"EventId": "'$eventId'"}]}' "http://169.254.169.254/metadata/scheduledevents?api-version=2017-08-01"
