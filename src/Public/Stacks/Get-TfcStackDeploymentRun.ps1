<#
.SYNOPSIS
    Lists deployment runs for a stack deployment group or deployment
.DESCRIPTION
    Retrieves deployment runs scoped either to a deployment group (-StackDeploymentGroupId)
    or to a specific deployment within a stack (-StackId + -DeploymentName).
.PARAMETER StackDeploymentGroupId
    The deployment group ID
.PARAMETER StackId
    The stack ID (use with -DeploymentName)
.PARAMETER DeploymentName
    The deployment name (use with -StackId)
.EXAMPLE
    Get-TfcStackDeploymentRun -StackDeploymentGroupId "sdg-abc123"
.EXAMPLE
    Get-TfcStackDeploymentRun -StackId "stack-abc123" -DeploymentName "production"
.OUTPUTS
    PSCustomObject representing the deployment runs
#>
function Get-TfcStackDeploymentRun {
    [CmdletBinding(DefaultParameterSetName = 'ByGroup')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'ByGroup')]
        [string]$StackDeploymentGroupId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByDeployment')]
        [string]$StackId,

        [Parameter(Mandatory = $true, ParameterSetName = 'ByDeployment')]
        [string]$DeploymentName
    )

    if ($PSCmdlet.ParameterSetName -eq 'ByGroup') {
        Write-Verbose "Listing deployment runs for group: $StackDeploymentGroupId"
        return Invoke-TfcApi -Uri "/stack-deployment-groups/$StackDeploymentGroupId/stack-deployment-runs"
    }

    Write-Verbose "Listing deployment runs for stack $StackId deployment '$DeploymentName'"
    return Invoke-TfcApi -Uri "/stacks/$StackId/stack-deployments/$DeploymentName/stack-deployment-runs"
}
