<#
.SYNOPSIS
    Cancels a stack deployment run
.DESCRIPTION
    Cancels an in-progress stack deployment run
.PARAMETER StackDeploymentRunId
    The deployment run ID
.EXAMPLE
    Stop-TfcStackDeploymentRun -StackDeploymentRunId "sdr-abc123"
.OUTPUTS
    None
#>
function Stop-TfcStackDeploymentRun {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentRunId
    )

    Write-Verbose "Cancelling deployment run: $StackDeploymentRunId"
    if ($PSCmdlet.ShouldProcess("Deployment Run: $StackDeploymentRunId", "Cancel deployment run")) {
        Invoke-TfcApi -Uri "/stack-deployment-runs/$StackDeploymentRunId/cancel" -Method POST | Out-Null
        Write-Output "Cancel requested for deployment run '$StackDeploymentRunId'"
    }
}
