<#
.SYNOPSIS
    Reruns a stack deployment group
.DESCRIPTION
    Reruns all deployments in a stack deployment group
.PARAMETER StackDeploymentGroupId
    The deployment group ID
.EXAMPLE
    Restart-TfcStackDeploymentGroup -StackDeploymentGroupId "sdg-abc123"
.OUTPUTS
    None
#>
function Restart-TfcStackDeploymentGroup {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentGroupId
    )

    Write-Verbose "Rerunning deployment group: $StackDeploymentGroupId"
    if ($PSCmdlet.ShouldProcess("Deployment Group: $StackDeploymentGroupId", "Rerun")) {
        Invoke-TfcApi -Uri "/stack-deployment-groups/$StackDeploymentGroupId/rerun" -Method POST | Out-Null
        Write-Output "Rerun requested for deployment group '$StackDeploymentGroupId'"
    }
}
