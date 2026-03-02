function Get-TfcVariableSetVariable {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,
        [Parameter(Mandatory = $false)]
        [string]$VariableId
    )

    Initialize-TfcConnection

    if ($VariableId) {
        Write-Verbose "Getting variable: $VariableId from variable set: $VariableSetId"
        return Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/vars/$VariableId" -Method GET
    } else {
        Write-Verbose "Listing all variables in variable set: $VariableSetId"
        return Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/vars" -Method GET
    }
}
