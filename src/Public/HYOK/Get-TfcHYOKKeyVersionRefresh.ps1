<#
.SYNOPSIS
    Refreshes HYOK key versions
.DESCRIPTION
    Queries for newly available key versions for a HYOK configuration
.PARAMETER ConfigurationId
    The HYOK configuration ID
.EXAMPLE
    Get-TfcHYOKKeyVersionRefresh -ConfigurationId "hyok-abc123"
.OUTPUTS
    PSCustomObject representing refreshed key version data
#>
function Get-TfcHYOKKeyVersionRefresh {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationId
    )

    Write-Verbose "Refreshing HYOK key versions for configuration: $ConfigurationId"
    return Invoke-TfcApi -Uri "/hyok-configurations/$ConfigurationId/key-versions?refresh"
}
