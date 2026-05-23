<#
.SYNOPSIS
    Lists deployment groups for a stack configuration
.DESCRIPTION
    Retrieves the deployment groups associated with a stack configuration. A
    deployment group ties one or more deployments together for coordinated execution.
.PARAMETER StackConfigurationId
    The stack configuration ID
.PARAMETER Name
    Optional deployment group name to retrieve a specific group by name
.EXAMPLE
    Get-TfcStackDeploymentGroup -StackConfigurationId "stackcfg-abc123"
.EXAMPLE
    Get-TfcStackDeploymentGroup -StackConfigurationId "stackcfg-abc123" -Name "prod-group"
.OUTPUTS
    PSCustomObject representing the deployment group(s)
#>
function Get-TfcStackDeploymentGroup {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackConfigurationId,

        [Parameter(Mandatory = $false)]
        [string]$Name
    )

    if ($Name) {
        Write-Verbose "Getting deployment group '$Name' for stack configuration: $StackConfigurationId"
        return Invoke-TfcApi -Uri "/stack-configurations/$StackConfigurationId/stack-deployment-groups/$Name"
    }

    Write-Verbose "Listing deployment groups for stack configuration: $StackConfigurationId"
    return Invoke-TfcApi -Uri "/stack-configurations/$StackConfigurationId/stack-deployment-groups"
}
