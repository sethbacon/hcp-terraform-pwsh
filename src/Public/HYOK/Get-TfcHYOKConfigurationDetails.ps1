<#
.SYNOPSIS
    Gets details of a specific HYOK configuration
.DESCRIPTION
    Retrieves detailed information about a specific Hold Your Own Key (HYOK) configuration
.PARAMETER ConfigurationId
    The ID of the HYOK configuration
.EXAMPLE
    Get-TfcHYOKConfigurationDetails -ConfigurationId "hyokc-abc123"
.OUTPUTS
    PSCustomObject representing the HYOK configuration
#>
function Get-TfcHYOKConfigurationDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationId
    )

    Write-Verbose "Getting details for HYOK configuration: $ConfigurationId"
    return Invoke-TfcApi -Uri "/hyok-configurations/$ConfigurationId" -Method GET
}
