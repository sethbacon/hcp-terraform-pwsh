<#
.SYNOPSIS
    Update no-code module variable options
.DESCRIPTION
    Upgrades the variable options for a no-code module
.PARAMETER NoCodeModuleId
    The ID of the no-code module (format: ncm-xxxxx)
.EXAMPLE
    Update-TfcNoCodeModuleVariableOptions -NoCodeModuleId ncm-abc123
#>
function Update-TfcNoCodeModuleVariableOptions {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NoCodeModuleId
    )

    Initialize-TfcConnection

    if ($PSCmdlet.ShouldProcess("No-Code Module: $NoCodeModuleId", "Update variable options")) {
        Write-Verbose "Updating variable options for no-code module: $NoCodeModuleId"
        return Invoke-TfcApi -Uri "/no-code-modules/$NoCodeModuleId/actions/upgrade-variable-options" -Method POST
    }
}
