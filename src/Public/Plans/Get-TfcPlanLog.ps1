<#
.SYNOPSIS
    Gets plan logs
.DESCRIPTION
    Retrieves the logs from a plan execution
.PARAMETER PlanId
    The plan ID
.PARAMETER Format
    Format: 'text' or 'json' (default: text)
.EXAMPLE
    Get-TfcPlanLog -PlanId "plan-abc123"
.OUTPUTS
    String containing plan logs
#>
function Get-TfcPlanLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PlanId
    )

    Write-Verbose "Getting logs for plan: $PlanId"
    $plan = Invoke-TfcApi -Uri "/plans/$PlanId"

    if ($plan.data.attributes.'log-read-url') {
        $logUrl = $plan.data.attributes.'log-read-url'
        Initialize-TfcConnection

        try {
            $response = Invoke-WebRequest -Uri $logUrl -Headers $script:TfcHeaders
            return $response.Content
        }
        catch {
            throw "Failed to retrieve plan logs: $($_.Exception.Message)"
        }
    }
    else {
        throw "No log URL available for plan $PlanId"
    }
}
