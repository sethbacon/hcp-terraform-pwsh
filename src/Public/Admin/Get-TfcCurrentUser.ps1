<#
.SYNOPSIS
    Gets user information from a token
.DESCRIPTION
    Retrieves user information for the specified user token
.PARAMETER UserToken
    The user token to get information for (if not provided, uses current token)
.EXAMPLE
    Get-TfcCurrentUser
.EXAMPLE
    Get-TfcCurrentUser -UserToken "user-token-here"
.OUTPUTS
    PSCustomObject representing the user information
#>
function Get-TfcCurrentUser {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'User-provided token string must be converted to SecureString for Invoke-RestMethod -Authentication Bearer')]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string]$UserToken
    )

    if ($UserToken) {
        $secureToken = ConvertTo-SecureString $UserToken -AsPlainText -Force
        $headers = @{'Content-Type' = 'application/vnd.api+json'}
        return Invoke-RestMethod -Uri "$script:TfcApiBaseUri/account/details" -Headers $headers -Authentication Bearer -Token $secureToken
    }
    else {
        return Get-TfcAccount
    }
}
