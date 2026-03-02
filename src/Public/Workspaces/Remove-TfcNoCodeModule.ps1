<#
.SYNOPSIS
    Remove a no-code module
.DESCRIPTION
    Deletes a no-code module from Terraform Cloud
.PARAMETER NoCodeModuleId
    The ID of the no-code module to delete (format: ncm-xxxxx)
.EXAMPLE
    Remove-TfcNoCodeModule -NoCodeModuleId ncm-abc123
#>
function Remove-TfcNoCodeModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NoCodeModuleId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("No-Code Module: $NoCodeModuleId", "Delete")) {
        Write-Verbose "Deleting no-code module: $NoCodeModuleId"
        return Invoke-TfcApi -Uri "/no-code-modules/$NoCodeModuleId" -Method DELETE
    }
}
