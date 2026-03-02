<#
.SYNOPSIS
    Cancel a stack deployment
.DESCRIPTION
    Cancels a running stack deployment
.PARAMETER DeploymentId
    The ID of the deployment to cancel
.EXAMPLE
    Stop-TfcStackDeployment -DeploymentId "sd-123"
#>
function Stop-TfcStackDeployment {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeploymentId
    )

    try {
        Initialize-TfcConnection

        $body = @{
            data = @{
                type = "stack-deployments"
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Deployment: $DeploymentId", "Cancel deployment")) {
            Write-Verbose "Cancelling deployment: $DeploymentId"
            return Invoke-TfcApi -Uri "/stack-deployments/$DeploymentId/actions/cancel" -Method POST -Body $body
        }
    }
    catch {
        throw "Failed to cancel deployment: $($_.Exception.Message)"
    }
}
