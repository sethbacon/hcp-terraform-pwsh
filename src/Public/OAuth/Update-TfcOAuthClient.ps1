<#
.SYNOPSIS
    Updates an OAuth client
.DESCRIPTION
    Updates an existing OAuth client configuration in Terraform Cloud
.PARAMETER OAuthClientId
    The ID of the OAuth client to update
.PARAMETER Name
    New display name for the OAuth client
.PARAMETER Key
    New OAuth application key/client ID
.PARAMETER Secret
    New OAuth application secret
.EXAMPLE
    Update-TfcOAuthClient -OAuthClientId "oc-123" -Name "Updated GitHub Connection"
.EXAMPLE
    Update-TfcOAuthClient -OAuthClientId "oc-123" -Key "new-key" -Secret "new-secret"
.OUTPUTS
    PSCustomObject representing the updated OAuth client
#>
function Update-TfcOAuthClient {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OAuthClientId,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Key,

        [Parameter(Mandatory = $false)]
        [string]$Secret
    )

    if ($PSCmdlet.ShouldProcess("OAuth Client $OAuthClientId", "Update OAuth client")) {
        $attributes = @{}

        if ($Name) { $attributes['name'] = $Name }
        if ($Key) { $attributes['key'] = $Key }
        if ($Secret) { $attributes['secret'] = $Secret }

        $body = @{
            data = @{
                type = 'oauth-clients'
                id = $OAuthClientId
                attributes = $attributes
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Updating OAuth client: $OAuthClientId"
        return Invoke-TfcApi -Uri "/oauth-clients/$OAuthClientId" -Method PATCH -Body $body
    }
}
