<#
.SYNOPSIS
    Gets audit trail events
.DESCRIPTION
    Retrieves audit trail events for compliance logging
.PARAMETER OrganizationName
    Optional organization name to filter events
.PARAMETER Since
    Optional start date for filtering
.PARAMETER AllPages
    Switch to retrieve all pages of results
.EXAMPLE
    Get-TfcAuditTrail -OrganizationName "my-org"
.OUTPUTS
    PSCustomObject representing audit trail events
#>
function Get-TfcAuditTrail {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $false)]
        [datetime]$Since,
        [switch]$AllPages
    )

    Initialize-TfcConnection

    $queryParams = @()

    if ($Since) {
        $sinceStr = $Since.ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
        $queryParams += "since=$sinceStr"
    }

    $uri = "/organizations/$OrganizationName/audit-trail"

    if ($queryParams.Count -gt 0) {
        $uri += "?" + ($queryParams -join "&")
    }

    Write-Verbose "Getting audit trail events"

    if ($AllPages) {
        return Get-AllPages -Uri $uri
    }

    return Invoke-TfcApi -Uri $uri
}
