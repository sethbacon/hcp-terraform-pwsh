<#
.SYNOPSIS
    List feature sets
.DESCRIPTION
    Retrieves available feature sets for Terraform Cloud
.EXAMPLE
    Get-TfcFeatureSet
#>
function Get-TfcFeatureSet {
    [CmdletBinding()]
    param()

    Initialize-TfcConnection
    Write-Verbose "Getting feature sets"
    return Invoke-TfcApi -Uri "/feature-sets" -Method GET
}
