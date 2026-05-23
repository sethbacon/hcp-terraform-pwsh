<#
.SYNOPSIS
    Advances a stack deployment step
.DESCRIPTION
    Signals a paused stack deployment step to proceed to the next stage
.PARAMETER StackDeploymentStepId
    The deployment step ID
.EXAMPLE
    Invoke-TfcStackDeploymentStepAdvance -StackDeploymentStepId "sds-abc123"
.OUTPUTS
    None
#>
function Invoke-TfcStackDeploymentStepAdvance {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackDeploymentStepId
    )

    Write-Verbose "Advancing deployment step: $StackDeploymentStepId"
    if ($PSCmdlet.ShouldProcess("Deployment Step: $StackDeploymentStepId", "Advance")) {
        Invoke-TfcApi -Uri "/stack-deployment-steps/$StackDeploymentStepId/advance" -Method POST | Out-Null
        Write-Output "Advance signal sent for deployment step '$StackDeploymentStepId'"
    }
}
