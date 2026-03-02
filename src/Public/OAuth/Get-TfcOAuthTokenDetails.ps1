<#
.SYNOPSIS
    Get detailed OAuth token information
.DESCRIPTION
    Retrieves detailed information about a specific OAuth token
.PARAMETER OAuthTokenId
    The ID of the OAuth token (format: ot-xxxxx)
.EXAMPLE
    Get-TfcOAuthTokenDetails -OAuthTokenId ot-abc123
#>
function Get-TfcOAuthTokenDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OAuthTokenId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for OAuth token: $OAuthTokenId"
    return Invoke-TfcApi -Uri "/oauth-tokens/$OAuthTokenId" -Method GET
}
