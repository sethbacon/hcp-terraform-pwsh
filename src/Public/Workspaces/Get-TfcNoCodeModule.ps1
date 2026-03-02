<#
.SYNOPSIS
    Get no-code module information
.DESCRIPTION
    Retrieves information about a no-code module
.PARAMETER NoCodeModuleId
    The ID of the no-code module (format: ncm-xxxxx)
.EXAMPLE
    Get-TfcNoCodeModule -NoCodeModuleId ncm-abc123
#>
function Get-TfcNoCodeModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NoCodeModuleId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting no-code module: $NoCodeModuleId"
    return Invoke-TfcApi -Uri "/no-code-modules/$NoCodeModuleId" -Method GET
}
