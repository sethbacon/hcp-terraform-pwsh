<#
.SYNOPSIS
    Removes a user token
.DESCRIPTION
    Deletes a user API token
.PARAMETER TokenId
    The token ID to delete
.EXAMPLE
    Remove-TfcUserToken -TokenId "at-abc123"
.OUTPUTS
    None
#>
function Remove-TfcUserToken {
    [OutputType([bool])]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$TokenId
    )

    if ($PSCmdlet.ShouldProcess("User Token $TokenId", "Delete")) {
        Write-Verbose "Deleting user token: $TokenId"
        Invoke-TfcApi -Uri "/authentication-tokens/$TokenId" -Method DELETE | Out-Null
        return $true
    }
}
