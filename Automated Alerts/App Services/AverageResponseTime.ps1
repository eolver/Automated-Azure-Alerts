param (

#Resource Group
$resourceGroupName = "",
#Action Group
$ActionGroupName = ""
)

#File Paths. I used this path you can choose any other.
$templateFilePath="$PSScriptRoot\..\template.json"
$parametersFilePath="$PSScriptRoot\..\parameters.json"
##################  RESOURCES ###########################################################################################
#Get Resources
$VMColl = Get-AzResource -ResourceType "Microsoft.Web/sites" | Select-Object -Property ResourceId,Name,Tags
######################################################################################################################### 

################## ACTION GROUP ##############################

$alertgroup=Get-AzActionGroup -ResourceGroupName $resourceGroupName -Name $ActionGroupName
Write-Host "Creating Metric Alerts for Apps"

################## PARAMETERS ##############################
foreach ($VMID in $VMColl){

#Parameters
$strVMID = $VMID.ResourceId
$strVMName = $VMID.Name

if (!$VMID.Tags.AverageResponseTime)
{


$metricName = "AverageResponseTime"
$alertName = $strVMName + " - " + $metricName 
$metricNamespace = "Microsoft.Web"
$threshold = "10"
$actionGroupId = $alertgroup.Id
$timeAggregation = "Average" # Average, Minimum, Maximum, Total
$alertDescription = ""
$operator = "GreaterThan" # Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual
$alertSeverity = 3 # 0,1,2,3,4
$evaluationFrequency = "PT5M"
$windowsSize = "PT5M"
}
 
else
{
    $metricName = "AverageResponseTime"
    $alertName = $strVMName + " - " + $metricName 
    $metricNamespace = "Microsoft.Web"
    $threshold = $VMID.Tags.AverageResponseTime
    $actionGroupId = $alertgroup.Id
    $timeAggregation = "Average" # Average, Minimum, Maximum, Total
    $alertDescription = ""
    $operator = "GreaterThan" # Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan, LessThanOrEqual
    $alertSeverity = 3 # 0,1,2,3,4
    $evaluationFrequency = "PT5M"
    $windowsSize = "PT5M"
}


#Get JSON
$paramFile = Get-Content $parametersFilePath -Raw | ConvertFrom-Json

#Update Values
$paramFile.parameters.alertName.value = $alertName
$paramFile.parameters.metricName.value = $metricName
$paramFile.parameters.metricNamespace.value = $metricNamespace
$paramFile.parameters.resourceId.value = $strVMID
$paramFile.parameters.threshold.value = $threshold
$paramFile.parameters.actionGroupId.value = $actionGroupId
$paramFile.parameters.timeAggregation.value = $timeAggregation
$paramFile.parameters.alertDescription.value = $alertDescription
$paramFile.parameters.operator.value = $operator
$paramFile.parameters.alertSeverity.value = $alertSeverity
$paramFile.parameters.evaluationFrequency.value = $evaluationFrequency
$paramFile.parameters.windowSize.value = $windowsSize


#Update JSON
$UpdatedJSON = $paramFile | ConvertTo-Json
$UpdatedJSON > $parametersFilePath

#Deploy Template
$DeploymentName = "$strVMName-$metricName"
$DeploymentName
$AlertDeployment = New-AzResourceGroupDeployment -Name $DeploymentName -ResourceGroupName $resourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath -AsJob 
} 