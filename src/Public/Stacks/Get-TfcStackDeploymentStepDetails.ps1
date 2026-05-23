<#
.SYNOPSIS
    Gets details for a stack deployment step
.DESCRIPTION
    Retrieves a single deployment step by ID
.PARAMETER StackDeploymentStepId
    The deployment step ID
.EXAMPLE
    Get-TfcStackDeploymentStepDetails -StackDeploymentStepId "sds-abc123"
.OUTPUTS
    PSCustomObject representing the deployment step
#>
function Get-TfcStackDeploymentStepDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentStepId
    )

    Write-Verbose "Getting deployment step details: $StackDeploymentStepId"
    return Invoke-TfcApi -Uri "/stack-deployment-steps/$StackDeploymentStepId"
}
