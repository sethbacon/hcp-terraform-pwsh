<#
.SYNOPSIS
    Gets details for a specific query run
.DESCRIPTION
    Retrieves a single query run by ID, including its current status and results
.PARAMETER QueryId
    The query run ID
.EXAMPLE
    Get-TfcQueryDetails -QueryId "qry-abc123"
.OUTPUTS
    PSCustomObject representing the query run
#>
function Get-TfcQueryDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$QueryId
    )

    Write-Verbose "Getting query details: $QueryId"
    return Invoke-TfcApi -Uri "/queries/$QueryId"
}
