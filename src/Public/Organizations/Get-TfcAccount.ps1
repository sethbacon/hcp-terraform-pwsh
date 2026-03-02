<#
.SYNOPSIS
    Gets the current user account information
.DESCRIPTION
    Retrieves information about the current user account from Terraform Cloud
.EXAMPLE
    Get-TfcAccount
.OUTPUTS
    PSCustomObject representing the user account
#>
function Get-TfcAccount {
    [CmdletBinding()]
    param()

    Write-Verbose "Getting current user account information"
    return Invoke-TfcApi -Uri '/account/details'
}
