<#
.SYNOPSIS
    Removes an OAuth client
.DESCRIPTION
    Deletes an OAuth client from Terraform Cloud. This will disconnect VCS integration for workspaces using this client.
.PARAMETER OAuthClientId
    The ID of the OAuth client to remove
.EXAMPLE
    Remove-TfcOAuthClient -OAuthClientId "oc-123"
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcOAuthClient {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OAuthClientId
    )

    if ($PSCmdlet.ShouldProcess("OAuth Client $OAuthClientId", "Delete OAuth client (will disconnect VCS integrations)")) {
        Write-Verbose "Deleting OAuth client: $OAuthClientId"
        Write-Warning "This will disconnect VCS integration for all workspaces using this OAuth client!"
        try {
            Invoke-TfcApi -Uri "/oauth-clients/$OAuthClientId" -Method DELETE
            return $true
        }
        catch {
            Write-Error "Failed to delete OAuth client: $_"
            return $false
        }
    }
}
