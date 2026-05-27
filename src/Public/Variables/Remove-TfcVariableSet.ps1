<#
.SYNOPSIS
    Removes a variable set
.DESCRIPTION
    Deletes a variable set from Terraform Cloud
.PARAMETER VariableSetId
    The variable set ID to delete
.EXAMPLE
    Remove-TfcVariableSet -VariableSetId "varset-abc123"
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcVariableSet {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId
    )

    if ($PSCmdlet.ShouldProcess($VariableSetId, "Delete variable set")) {
        Write-Verbose "Deleting variable set: $VariableSetId"
        try {
            Invoke-TfcApi -Uri "/varsets/$VariableSetId" -Method DELETE | Out-Null
            return $true
        }
        catch {
            Write-Error "Failed to delete variable set: $_"
            return $false
        }
    }
}
