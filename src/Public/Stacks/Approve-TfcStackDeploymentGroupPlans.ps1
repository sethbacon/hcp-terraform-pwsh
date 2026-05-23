<#
.SYNOPSIS
    Approves all plans in a stack deployment group
.DESCRIPTION
    Approves all pending plans for the deployments in a deployment group
.PARAMETER StackDeploymentGroupId
    The deployment group ID
.EXAMPLE
    Approve-TfcStackDeploymentGroupPlans -StackDeploymentGroupId "sdg-abc123"
.OUTPUTS
    None
#>
function Approve-TfcStackDeploymentGroupPlans {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentGroupId
    )

    Write-Verbose "Approving all plans in deployment group: $StackDeploymentGroupId"
    if ($PSCmdlet.ShouldProcess("Deployment Group: $StackDeploymentGroupId", "Approve all plans")) {
        Invoke-TfcApi -Uri "/stack-deployment-groups/$StackDeploymentGroupId/approve-all-plans" -Method POST | Out-Null
        Write-Output "Approved all plans in deployment group '$StackDeploymentGroupId'"
    }
}
