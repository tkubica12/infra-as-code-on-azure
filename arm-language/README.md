# Azure: ARM templates tutorial
- [Azure: ARM templates tutorial](#azure-arm-templates-tutorial)
    - [demo01 - simple IP address](#demo01---simple-ip-address)
    - [demo02 - change IP address name and demonstrate difference between increment and complete deployment](#demo02---change-ip-address-name-and-demonstrate-difference-between-increment-and-complete-deployment)
    - [demo03 - variables](#demo03---variables)
    - [demo04 - variables, getting location from resource group default](#demo04---variables-getting-location-from-resource-group-default)
    - [demo05 - parameters](#demo05---parameters)
    - [demo06 - loop](#demo06---loop)
    - [demo07 - loop over array](#demo07---loop-over-array)
    - [demo08 - enhanced loop](#demo08---enhanced-loop)
    - [demo09 - nested templates](#demo09---nested-templates)
    - [demo10 - nested templates in a loop](#demo10---nested-templates-in-a-loop)
    - [troubleshooting](#troubleshooting)
    
There a lot of great examples of ARM templates, but most of them try to demonstrate something useful like creating VMs. For purpose of showing ARM syntax and capabilities I needed something that shows power of ARM constructs with something that gets created very fast. This is set of examples to play with IP addresses, which is quick to create and good to start learning ARM itself. Note that none of those examples are complete solution. Please look for other templates on GitHub that would show comprehensive infrastructure being created.

## demo01 - simple IP address
```
az group deployment create --template-file demo01.json -g arm
```

## demo02 - change IP address name and demonstrate difference between increment and complete deployment
```
az group deployment create --template-file demo02.json -g arm
az group deployment create --template-file demo02.json -g arm --mode Complete
```

## demo03 - variables
```
az group deployment create --template-file demo03.json -g arm
```

## demo04 - variables, getting location from resource group default
```
az group deployment create --template-file demo04.json -g arm
```

## demo05 - parameters
```
az group deployment create --template-file demo05.json --parameters "@demo05.parameters.json" -g arm --mode Complete
```

## demo06 - loop
```
az group deployment create --template-file demo06.json --parameters "@demo06.parameters.json" -g arm --mode Complete
```

## demo07 - loop over array
```
az group deployment create --template-file demo07.json --parameters "@demo07.parameters.json" -g arm --mode Complete
```

## demo08 - enhanced loop
```
az group deployment create --template-file demo08.json --parameters "@demo08.parameters.json" -g arm --mode Complete
```

## demo09 - nested templates
```
az group deployment create --template-file demo09main.json --parameters "@demo09.parameters.json" -g arm 
```

## demo10 - nested templates in a loop
```
az group deployment create --template-file demo10main.json --parameters "@demo10.parameters.json" -g arm 
```

## troubleshooting
```
az group deployment operation list --name demo08  --resource-group arm
```

Tomas Kubica

Find me on linkedin.com/in/tkubica