<#
.SYNOPSIS
    Lists deployment steps for a deployment run
.DESCRIPTION
    Retrieves the individual steps that make up a stack deployment run
.PARAMETER StackDeploymentRunId
    The deployment run ID
.EXAMPLE
    Get-TfcStackDeploymentStep -StackDeploymentRunId "sdr-abc123"
.OUTPUTS
    PSCustomObject representing the deployment steps
#>
function Get-TfcStackDeploymentStep {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentRunId
    )

    Write-Verbose "Listing deployment steps for run: $StackDeploymentRunId"
    return Invoke-TfcApi -Uri "/stack-deployment-runs/$StackDeploymentRunId/stack-deployment-steps"
}
