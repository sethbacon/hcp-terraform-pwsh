<#
.SYNOPSIS
    Approves all plans in a stack deployment run
.DESCRIPTION
    Approves all pending plans for a stack deployment run
.PARAMETER StackDeploymentRunId
    The deployment run ID
.EXAMPLE
    Approve-TfcStackDeploymentRunPlans -StackDeploymentRunId "sdr-abc123"
.OUTPUTS
    None
#>
function Approve-TfcStackDeploymentRunPlans {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentRunId
    )

    Write-Verbose "Approving all plans in deployment run: $StackDeploymentRunId"
    if ($PSCmdlet.ShouldProcess("Deployment Run: $StackDeploymentRunId", "Approve all plans")) {
        Invoke-TfcApi -Uri "/stack-deployment-runs/$StackDeploymentRunId/approve-all-plans" -Method POST | Out-Null
        Write-Output "Approved all plans in deployment run '$StackDeploymentRunId'"
    }
}
