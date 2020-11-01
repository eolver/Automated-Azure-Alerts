# Automated-Azure-Alerts


Deploying Alerts to Azure resources scoped at the subsription level using ARM Templates, PowerShell and Azure Devops. 

This makes putting monitoring across all components in your subscription very fast, re-usable. 

Its also super quick to setup at scale and 100% re-runable, In this repo I have defined some of the alerts which could be useful for some PaaS components.

There is folder for 1 resource, and each of its metric namespaces you may want to monitor, all scripts reference the template.json and parameters.json file.

It will set the alert for every matching resource type within the subscription.

There is also logic in the script where if 1 of the resources requires a different threshold value than the others (Eg one app service is acceptable to have 10 seconds where the other 80 need a min of 2 seconds response time) you can add the metric name as a tag to that resoure and set the tag value as the threshhold value required.

Tag: AverageResponseTime
Value: 10

the following 2 variables need to be defined for the script to successfully execute. (the action group must recide in the resource group defined)

-Resource Group Name
-Action Group Name



## Overview

![ARM and Azure Devops](https://etsaustorage.blob.core.windows.net/$web/images/github/armps1.jpg)


Objective: Automate the process for setting up alerts via Azure DevOps Pipeline for all resources in Azure.

### Required: Azure Devops and Azure Portal Account

### Optional: Visual Studio Code

### Useful Links:
[Azure Metric Namespace](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/metrics-supported)



#### Setup the Project in Azure Devops

Create a new Project in Azure Devops, sign into your subscription so you can begin to build the pipelines.


#### Creating the Respository for CI in Git

Once you have got the project created, create a new Git Repo where you can store your ARM templates.Once you have a folder, add all the templates, to begin with we will add only template.JSON and one parameter.JSON for a App Service Plan

#### Setup Visual Studio Code for CI 

When the repo is created it will prompt to 'Clone in VS Code' which will automatically open and clone the Repo locally for future edits and publishing. Alternatively you can upload and directly edit the templates in Azure Devops.

#### Create the Build Pipeline to publish the template as an artifact

Each time you edit, update a script you want a new build artifact so you can select the template in the release pipeline

![ARM and Azure Devops](https://etsaustorage.blob.core.windows.net/$web/images/github/artifact.jpg)



#### Creating Release Pipeline

The first pipeline we are going to create is purely for release and deployment of the alerts. We will copy and publish the ARM templates as an artifact. This is a zipped version of the folder with the contents, we will enable Continious Intergration so that each change we make or add to it will automatically trigger for the build pipeline to create a new build artifact with the changes.

#### Setup the Action Group in Azure

[Setup the action group](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/action-groups) in Azure to where you want the alerts to be sent



#### Define the variables on the release pipeline and deploy

Once you have selected the Resource Type and alert metric to monitor you need to define the Resource Group and Action Group.

![Azure Powershell Tasks](https://etsaustorage.blob.core.windows.net/$web/images/github/alertspipeline.JPG)


![Script Arguements](https://etsaustorage.blob.core.windows.net/$web/images/github/scriptarguements.JPG)

