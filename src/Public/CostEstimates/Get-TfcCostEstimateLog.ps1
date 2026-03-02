<#
.SYNOPSIS
    Download cost estimate logs
.DESCRIPTION
    Downloads the logs for a cost estimate
.PARAMETER CostEstimateId
    The ID of the cost estimate (format: ce-xxxxx)
.EXAMPLE
    Get-TfcCostEstimateLog -CostEstimateId ce-abc123
#>
function Get-TfcCostEstimateLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CostEstimateId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting cost estimate logs for: $CostEstimateId"
    $logUrl = (Invoke-TfcApi -Uri "/cost-estimates/$CostEstimateId" -Method GET).data.attributes.'log-read-url'

    if ($logUrl) {
        $response = Invoke-WebRequest -Uri $logUrl -UseBasicParsing
        return $response.Content
    }
    else {
        Write-Warning "No log URL available for cost estimate: $CostEstimateId"
        return $null
    }
}
