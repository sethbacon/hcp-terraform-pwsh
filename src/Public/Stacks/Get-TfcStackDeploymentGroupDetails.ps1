<#
.SYNOPSIS
    Gets details for a specific stack deployment group
.DESCRIPTION
    Retrieves a deployment group by ID
.PARAMETER StackDeploymentGroupId
    The deployment group ID
.EXAMPLE
    Get-TfcStackDeploymentGroupDetails -StackDeploymentGroupId "sdg-abc123"
.OUTPUTS
    PSCustomObject representing the deployment group
#>
function Get-TfcStackDeploymentGroupDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentGroupId
    )

    Write-Verbose "Getting deployment group details: $StackDeploymentGroupId"
    return Invoke-TfcApi -Uri "/stack-deployment-groups/$StackDeploymentGroupId"
}
