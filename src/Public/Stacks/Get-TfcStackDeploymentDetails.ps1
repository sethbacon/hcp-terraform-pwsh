<#
.SYNOPSIS
    Get stack deployment details
.DESCRIPTION
    Retrieves detailed information about a specific stack deployment
.PARAMETER DeploymentId
    The ID of the deployment
.EXAMPLE
    Get-TfcStackDeploymentDetails -DeploymentId "sd-123"
.OUTPUTS
    PSCustomObject representing the deployment
#>
function Get-TfcStackDeploymentDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeploymentId
    )

    try {
        Initialize-TfcConnection
        Write-Verbose "Getting deployment details: $DeploymentId"
        return Invoke-TfcApi -Uri "/stack-deployments/$DeploymentId" -Method GET
    }
    catch {
        throw "Failed to get deployment details: $($_.Exception.Message)"
    }
}
