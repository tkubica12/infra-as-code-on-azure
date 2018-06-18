# Infrastructure as Code on Azure demos

This repository contains various demos presented on DevOps Bootcamp Praha 2018 by Tomas Kubica. 

Each example contains deploy.ps1 or deploy.sh with instructions how to deploy that demo.

Presentation from event (in Czech) is available [here](Infrastructure-as-Code.pdf)

Visit my blog (in Czech) about Azure on [https://tomaskubica.cz](https://tomaskubica.cz)

# ARM basics (arm-language)

This demonstrates some basic ARM syntax principles described here:

* Template structure with parameters and variables
* Output from template
* Creating unique strings
* Looping
* JSON object as parameter input
* Nested template to deploy to different resource group
* Linked nested template as building block

# Multiple Web Apps with Azure SQL in SaaS scenario (arm-webapps)

Using ARM templates to deploy infrastructure for SaaS solution where each customer has separate instance (Web App) and separate Azure SQL DB (part of elastic pool). Object parameter is used to provide complete list of customers (instances). Certificate is deployed (make sure you put there your own as parameter - contents of your PFX file with base64 encoding; in Bash you can use cat mycert.pfx | base64 -w 0). Also host binding is created and DNS registered in Azure DNS (make sure you have some DNS zone of your own). Staging slot is also deployed with SQL DB, but not registered with custom domain or certificate. Follow instructions in deploy.ps1.

# ARM IaaS (arm-iaas)

Template creates multiple frontend VMs with public IP load balancer and multiple backend VMs with private IP load balancer. Number of VMs in each tier is specified as parameter. Follow instructions in deploy.ps1.

# Storing secrets in Azure Key Vault and use with ARM deployment and Managed Service Identity in VMs or App Services (secrets-keyvault)

In this demo we demonstrate how to remove secrets (passwords, keys, certificates) from deployment processes or configuration files. We will create Key Vault and store our secret there. We than reference this secret during ARM deployment to set password for Azure Database for MySQL. Then we will use Managed Services Identity with VM and demonstrate how application can use MSI account to pickup database password from Key Vault.

# Terraform as multi-cloud infrastructure deployment solution (terraform)

Terraform is open-source cross-platform multi-cloud declarative tool to deploy infrastructure. It is similar to native ARM, but supports other clouds and on-premises platforms. This example shows complex terraform infrastructure with reusable modules. main.tf contains main declarative state infrastructure with some inputs. Modules are used to create reusable infrastructure as code and setup production and test environment. Shared services module creates network. Web module creates couple of VMs and load balancer. App module creates container registry and managed Kubernetes cluster. Database module prepares Azure SQL DB. Follow instructions in deploy.sh.

# Deploy Windows configuration with ARM and DSC extension (extension-dsc-iis)

Simple ARM template deployes Windows VM and than DSC extension is used to configure OS. Follow instructions in deploy.ps1 in order to get your DSC file uploaded to storage location and referenced by ARM. Purpose of this demo is to leverage DSC to configure IIS on target system. Follow instructions in deploy.ps1.

# Configure Domain Services via DSC and automaticaly join new VM to domain (extension-joindomain)

In first part of our demo we will use again ARM with DSC extension to deploy Windows machine and configure it. This time to enable Domain Services, DNS role and promote machine to DC role. Next we will deploy another Windows VM and use Join Domain Extension to make it automatically joined as part of our ARM deployment process. Follow instructions in deploy.ps1.

# Prepare Azure Automation DSC and use it to manage VM configurations (automation-dsc)

First we will deploy Azure Automation account with ARM template and prepare it for IIS configurations by importing proper Modules, Configurations and make it compiled. As part of template plain Windows VM will be deployed. Next use Azure portal to register this VM with Azure Automation and apply IIS configuration to it. Follow instructions in deploy.ps1.

# Automate Linux OS during first start with multi-cloud cloud-init (cloud-init)

In this demo you will se usage of standard cloud-init to configure Linux system after first start. In our case we will register new repositories, install various packages and run script to do configurations. Purpose of this demo is to automatically create workstation (jump-server) to operate Kubernetes such as AKS (installs GUI, remote desktop, kubectl, Helm, Docker, VS Code with various plugins). Follow instructions in deploy.sh.

# Deploy infrastructure and configure Linux VMs with Ansible roles (ansible)

In this demo we will use Ansible as single tool to create infrastructure in Azure as well as configure Linux VMs for Apache or NGINX. You can use jump server from previous demo (cloud-init). We will also demonstrate dynamic inventory plugin for Azure so you can use other methods to deply infrastructure (such as ARM or Terraform) and continue with Ansible to deploy services to VMs.

# Using ACI as scripting node for PaaS services in ARM (arm-db-aci-script)

When deploying database into VM for your CI/CD purposes you can use tools like script extension ro Ansible to load testing data. This is not available for PaaS databases. You may script data load from your CI/CD system, which is OK for internal situation, but not ideal when building for example ARM template for trial or self deployment. In this demo we use ACI container to run one-shot script to move data.

# Leverage Low-priority VMs to lower your cost of batch operations (batch-transcoding)

Azure Batch is orchestration platform to create VM resources, install basic environments and application and schedule batch long-running tasks such as video transcoding, rendering or ML training jobs. It can automatically scale cluster (number of VMs) based on task queue lenght. Azure Batch support Low Priority VMs (machines with no guarantees leveraging spare resource) with significant discounts. In our demo we will use Azure Batch to transcode video files in Blob storage. For purpose of demo standard VMs are used, but you can easily change it to Low Priority SKUs.

# Prepare Managed Application and publish it to your internal app catalog in Azure (managedapp)

In this demo we are going to publish ARM template to service catalog (internal to company) together with UI definition. Users can deploy this (kind of internal SaaS model) and in our example user gets read only access while central IT maintains full rights. Similar definition structure is used when publishing to public catalog by ISVs. Follow instructions in deploy.ps1.

# Trial workflow for your SaaS app using ARM, containers and Logic Apps (trial-workflow)

In this demo we will leverage packaging application to containers, run it quickly in Azure Container Instance and leverage Logic Apps to model worflow around it for trial scenarios. Our SaaS app will be Wordpress consisting of app container and db container. Our workflow will start on http request trigger (eg. when customer fill in form on company web site to get trial deployment). We will create resource group and use ARM to deploy app into ACI. Then we gather public IP and send login details to customer via email. Trial period is then started. After trial period is over we send email to customer and delete environment.

# Reading Azure metadata from VM and reacting on it in your code

TBD



