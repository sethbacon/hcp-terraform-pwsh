<#
.SYNOPSIS
    List OAuth tokens for an OAuth client
.DESCRIPTION
    Retrieves all OAuth tokens associated with an OAuth client
.PARAMETER OAuthClientId
    The ID of the OAuth client (format: oc-xxxxx)
.EXAMPLE
    Get-TfcOAuthToken -OAuthClientId oc-abc123
#>
function Get-TfcOAuthToken {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OAuthClientId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting OAuth tokens for client: $OAuthClientId"
    return Invoke-TfcApi -Uri "/oauth-clients/$OAuthClientId/oauth-tokens" -Method GET
}
