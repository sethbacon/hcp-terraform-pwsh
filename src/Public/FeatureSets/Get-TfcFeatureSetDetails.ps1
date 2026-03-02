<#
.SYNOPSIS
    Get detailed feature set information
.DESCRIPTION
    Retrieves detailed information about a specific feature set
.PARAMETER FeatureSetId
    The ID of the feature set (format: fs-xxxxx)
.EXAMPLE
    Get-TfcFeatureSetDetails -FeatureSetId fs-abc123
#>
function Get-TfcFeatureSetDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$FeatureSetId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for feature set: $FeatureSetId"
    return Invoke-TfcApi -Uri "/feature-sets/$FeatureSetId" -Method GET
}
