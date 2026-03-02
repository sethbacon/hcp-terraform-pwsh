<#
.SYNOPSIS
    Get admin organization settings
.DESCRIPTION
    Retrieves administrative settings for Terraform Cloud (requires admin access)
.EXAMPLE
    Get-TfcAdminSettings
#>
function Get-TfcAdminSettings {
    [CmdletBinding()]
    param()

    Initialize-TfcConnection
    Write-Verbose "Getting admin settings"
    return Invoke-TfcApi -Uri "/admin/settings" -Method GET
}
