<#
.SYNOPSIS
    Gets ingress attributes for a configuration version
.DESCRIPTION
    Retrieves the ingress attributes (VCS metadata) associated with a configuration version
.PARAMETER ConfigurationVersionId
    The configuration version ID
.EXAMPLE
    Get-TfcConfigurationVersionIngressAttributes -ConfigurationVersionId "cv-abc123"
.OUTPUTS
    PSCustomObject representing the ingress attributes
#>
function Get-TfcConfigurationVersionIngressAttributes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfigurationVersionId
    )

    Initialize-TfcConnection

    Write-Verbose "Getting ingress attributes for configuration version: $ConfigurationVersionId"
    return Invoke-TfcApi -Uri "/configuration-versions/$ConfigurationVersionId/ingress-attributes" -Method GET
}
