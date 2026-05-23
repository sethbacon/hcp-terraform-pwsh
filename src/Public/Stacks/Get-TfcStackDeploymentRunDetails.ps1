<#
.SYNOPSIS
    Gets details for a stack deployment run
.DESCRIPTION
    Retrieves a single deployment run by ID
.PARAMETER StackDeploymentRunId
    The deployment run ID
.EXAMPLE
    Get-TfcStackDeploymentRunDetails -StackDeploymentRunId "sdr-abc123"
.OUTPUTS
    PSCustomObject representing the deployment run
#>
function Get-TfcStackDeploymentRunDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentRunId
    )

    Write-Verbose "Getting deployment run details: $StackDeploymentRunId"
    return Invoke-TfcApi -Uri "/stack-deployment-runs/$StackDeploymentRunId"
}
