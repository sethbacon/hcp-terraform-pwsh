<#
.SYNOPSIS
    Lists diagnostics for a stack deployment step
.DESCRIPTION
    Retrieves the diagnostic messages emitted while executing a deployment step
.PARAMETER StackDeploymentStepId
    The deployment step ID
.EXAMPLE
    Get-TfcStackDeploymentStepDiagnostic -StackDeploymentStepId "sds-abc123"
.OUTPUTS
    PSCustomObject representing the step diagnostics
#>
function Get-TfcStackDeploymentStepDiagnostic {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentStepId
    )

    Write-Verbose "Getting diagnostics for deployment step: $StackDeploymentStepId"
    return Invoke-TfcApi -Uri "/stack-deployment-steps/$StackDeploymentStepId/stack-diagnostics"
}
