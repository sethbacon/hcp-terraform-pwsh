<#
.SYNOPSIS
    Get detailed run information
.DESCRIPTION
    Retrieves detailed information about a specific run including relationships and additional data
.PARAMETER RunId
    The ID of the run (format: run-xxxxx)
.EXAMPLE
    Get-TfcRunDetails -RunId run-abc123
#>
function Get-TfcRunDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for run: $RunId"
    return Invoke-TfcApi -Uri "/runs/$RunId" -Method GET
}
