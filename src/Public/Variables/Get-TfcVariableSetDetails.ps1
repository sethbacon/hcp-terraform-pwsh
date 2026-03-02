<#
.SYNOPSIS
    Gets details of a specific variable set
.DESCRIPTION
    Retrieves detailed information about a variable set by its ID
.PARAMETER VariableSetId
    The variable set ID
.EXAMPLE
    Get-TfcVariableSetDetails -VariableSetId "varset-abc123"
.OUTPUTS
    PSCustomObject representing the variable set details
#>
function Get-TfcVariableSetDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId
    )

    Initialize-TfcConnection

    Write-Verbose "Getting variable set details for: $VariableSetId"
    return Invoke-TfcApi -Uri "/varsets/$VariableSetId" -Method GET
}
