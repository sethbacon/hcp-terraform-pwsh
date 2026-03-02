<#
.SYNOPSIS
    Gets user tokens
.DESCRIPTION
    Retrieves API tokens for the current user
.EXAMPLE
    Get-TfcUserToken
.OUTPUTS
    PSCustomObject representing user tokens
#>
function Get-TfcUserToken {
    [CmdletBinding()]
    param()

    Write-Verbose "Getting user tokens"
    return Invoke-TfcApi -Uri "/users/current/authentication-tokens"
}
