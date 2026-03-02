<#
.SYNOPSIS
    Gets a specific configuration version
.DESCRIPTION
    Retrieves details of a specific configuration version by ID
.PARAMETER ConfigurationVersionId
    The configuration version ID
.EXAMPLE
    Get-TfcConfigurationVersion -ConfigurationVersionId "cv-abc123"
.OUTPUTS
    PSCustomObject representing the configuration version
#>
function Get-TfcConfigurationVersion {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationVersionId
    )

    Write-Verbose "Getting configuration version: $ConfigurationVersionId"
    return Invoke-TfcApi -Uri "/configuration-versions/$ConfigurationVersionId"
}
