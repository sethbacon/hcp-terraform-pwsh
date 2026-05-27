function Remove-TfcVariableSetVariable {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,
        [Parameter(Mandatory = $true)]
        [string]$VariableId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("Variable '$VariableId'", "Delete from variable set '$VariableSetId'")) {
        Write-Verbose "Removing variable '$VariableId' from variable set: $VariableSetId"
        Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/vars/$VariableId" -Method DELETE | Out-Null
        return $true
    }
}
