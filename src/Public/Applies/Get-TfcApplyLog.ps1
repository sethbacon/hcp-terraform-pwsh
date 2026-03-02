<#
.SYNOPSIS
    Gets apply logs
.DESCRIPTION
    Retrieves the logs from an apply execution
.PARAMETER ApplyId
    The apply ID
.EXAMPLE
    Get-TfcApplyLog -ApplyId "apply-abc123"
.OUTPUTS
    String containing apply logs
#>
function Get-TfcApplyLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ApplyId
    )

    Write-Verbose "Getting logs for apply: $ApplyId"
    $apply = Invoke-TfcApi -Uri "/applies/$ApplyId"

    if ($apply.data.attributes.'log-read-url') {
        $logUrl = $apply.data.attributes.'log-read-url'
        Initialize-TfcConnection

        try {
            $response = Invoke-WebRequest -Uri $logUrl -Headers $script:TfcHeaders
            return $response.Content
        }
        catch {
            throw "Failed to retrieve apply logs: $($_.Exception.Message)"
        }
    }
    else {
        throw "No log URL available for apply $ApplyId"
    }
}
