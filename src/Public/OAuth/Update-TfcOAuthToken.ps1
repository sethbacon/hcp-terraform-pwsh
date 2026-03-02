<#
.SYNOPSIS
    Update an OAuth token
.DESCRIPTION
    Updates an OAuth token's SSH key
.PARAMETER OAuthTokenId
    The ID of the OAuth token (format: ot-xxxxx)
.PARAMETER SSHKeyId
    The ID of the SSH key to associate (format: sshkey-xxxxx)
.EXAMPLE
    Update-TfcOAuthToken -OAuthTokenId ot-abc123 -SSHKeyId sshkey-xyz789
#>
function Update-TfcOAuthToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OAuthTokenId,
        [Parameter(Mandatory = $false)]
        [string]$SSHKeyId
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "oauth-tokens"
            attributes = @{}
        }
    }

    if ($SSHKeyId) {
        $body.data.relationships = @{
            "ssh-key" = @{
                data = @{
                    type = "ssh-keys"
                    id = $SSHKeyId
                }
            }
        }
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("OAuth Token: $OAuthTokenId", "Update")) {
        Write-Verbose "Updating OAuth token: $OAuthTokenId"
        return Invoke-TfcApi -Uri "/oauth-tokens/$OAuthTokenId" -Method PATCH -Body $bodyJson
    }
}
