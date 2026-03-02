<#
.SYNOPSIS
    Gets detailed OAuth client information
.DESCRIPTION
    Retrieves detailed OAuth client information with relationships
.PARAMETER OAuthClientId
    The ID of the OAuth client to retrieve
.PARAMETER Include
    Optional comma-separated list of relationships to include (e.g., "organization,oauth-tokens")
.EXAMPLE
    Get-TfcOAuthClientDetails -OAuthClientId "oc-123"
.EXAMPLE
    Get-TfcOAuthClientDetails -OAuthClientId "oc-123" -Include "organization,oauth-tokens"
.OUTPUTS
    PSCustomObject with detailed OAuth client information
#>
function Get-TfcOAuthClientDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OAuthClientId,

        [Parameter(Mandatory = $false)]
        [string]$Include
    )

    $uri = "/oauth-clients/$OAuthClientId"

    if ($Include) {
        $uri += "?include=$Include"
    }

    Write-Verbose "Getting detailed OAuth client information: $OAuthClientId"
    return Invoke-TfcApi -Uri $uri
}
