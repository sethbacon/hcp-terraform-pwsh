<#
.SYNOPSIS
    Get stack deployment logs
.DESCRIPTION
    Retrieves logs for a stack deployment
.PARAMETER DeploymentId
    The ID of the deployment
.PARAMETER OutputPath
    Optional file path to save logs
.EXAMPLE
    Get-TfcStackDeploymentLog -DeploymentId "sd-123"
.EXAMPLE
    Get-TfcStackDeploymentLog -DeploymentId "sd-123" -OutputPath "./deployment.log"
.OUTPUTS
    String containing the deployment logs
#>
function Get-TfcStackDeploymentLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$DeploymentId,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    try {
        Initialize-TfcConnection
        Write-Verbose "Getting deployment logs: $DeploymentId"

        $deployment = Invoke-TfcApi -Uri "/stack-deployments/$DeploymentId" -Method GET

        if ($deployment.data.attributes.'log-read-url') {
            $logUrl = $deployment.data.attributes.'log-read-url'
            $logs = Invoke-RestMethod -Uri $logUrl -Method GET

            if ($OutputPath) {
                $logs | Out-File -FilePath $OutputPath -Encoding UTF8
                Write-Verbose "Logs saved to: $OutputPath"
            }

            return $logs
        }
        else {
            Write-Warning "Logs not yet available for deployment: $DeploymentId"
            return $null
        }
    }
    catch {
        throw "Failed to get deployment logs: $($_.Exception.Message)"
    }
}
