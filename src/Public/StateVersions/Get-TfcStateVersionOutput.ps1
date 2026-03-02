<#
.SYNOPSIS
    Gets state version outputs
.DESCRIPTION
    Retrieves outputs from a specific state version
.PARAMETER StateVersionId
    The state version ID
.EXAMPLE
    Get-TfcStateVersionOutput -StateVersionId "sv-abc123"
.OUTPUTS
    PSCustomObject representing the state version outputs
#>
function Get-TfcStateVersionOutput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StateVersionId
    )

    Write-Verbose "Getting outputs for state version: $StateVersionId"
    return Invoke-TfcApi -Uri "/state-versions/$StateVersionId/outputs"
}
