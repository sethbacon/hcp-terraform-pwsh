<#
.SYNOPSIS
    Remove an OAuth token
.DESCRIPTION
    Deletes an OAuth token from Terraform Cloud
.PARAMETER OAuthTokenId
    The ID of the OAuth token to delete (format: ot-xxxxx)
.EXAMPLE
    Remove-TfcOAuthToken -OAuthTokenId ot-abc123
#>
function Remove-TfcOAuthToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OAuthTokenId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("OAuth Token: $OAuthTokenId", "Delete")) {
        Write-Verbose "Deleting OAuth token: $OAuthTokenId"
        return Invoke-TfcApi -Uri "/oauth-tokens/$OAuthTokenId" -Method DELETE
    }
}
