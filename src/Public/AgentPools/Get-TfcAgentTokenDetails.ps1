<#
.SYNOPSIS
    Gets details of an agent token
.DESCRIPTION
    Retrieves details of a specific authentication token by ID
.PARAMETER TokenId
    The authentication token ID
.EXAMPLE
    Get-TfcAgentTokenDetails -TokenId "at-abc123"
.OUTPUTS
    PSCustomObject representing the token details
#>
function Get-TfcAgentTokenDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TokenId
    )

    Write-Verbose "Getting agent token details: $TokenId"
    return Invoke-TfcApi -Uri "/authentication-tokens/$TokenId"
}
