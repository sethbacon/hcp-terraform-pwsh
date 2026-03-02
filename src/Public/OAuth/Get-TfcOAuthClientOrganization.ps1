<#
.SYNOPSIS
    Gets OAuth client organizations
.DESCRIPTION
    Retrieves the organization associated with an OAuth client
.PARAMETER OAuthClientId
    The ID of the OAuth client to get organization for
.EXAMPLE
    Get-TfcOAuthClientOrganization -OAuthClientId "oc-123"
.OUTPUTS
    PSCustomObject representing the organization
#>
function Get-TfcOAuthClientOrganization {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OAuthClientId
    )

    Write-Verbose "Getting organization for OAuth client: $OAuthClientId"
    return Invoke-TfcApi -Uri "/oauth-clients/$OAuthClientId/organization"
}
