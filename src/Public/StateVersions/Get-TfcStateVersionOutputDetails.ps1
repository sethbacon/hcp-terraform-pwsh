<#
.SYNOPSIS
    Gets details of a state version output
.DESCRIPTION
    Retrieves details of a specific state version output by ID
.PARAMETER StateVersionOutputId
    The state version output ID
.EXAMPLE
    Get-TfcStateVersionOutputDetails -StateVersionOutputId "wsout-abc123"
.OUTPUTS
    PSCustomObject representing the state version output details
#>
function Get-TfcStateVersionOutputDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StateVersionOutputId
    )

    Write-Verbose "Getting state version output details: $StateVersionOutputId"
    return Invoke-TfcApi -Uri "/state-version-outputs/$StateVersionOutputId"
}
