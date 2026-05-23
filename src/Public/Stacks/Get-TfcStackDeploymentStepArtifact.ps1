<#
.SYNOPSIS
    Lists artifacts produced by a stack deployment step
.DESCRIPTION
    Retrieves the artifacts emitted by a completed deployment step
.PARAMETER StackDeploymentStepId
    The deployment step ID
.EXAMPLE
    Get-TfcStackDeploymentStepArtifact -StackDeploymentStepId "sds-abc123"
.OUTPUTS
    PSCustomObject representing the step artifacts
#>
function Get-TfcStackDeploymentStepArtifact {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentStepId
    )

    Write-Verbose "Getting artifacts for deployment step: $StackDeploymentStepId"
    return Invoke-TfcApi -Uri "/stack-deployment-steps/$StackDeploymentStepId/artifacts"
}
