<#
.SYNOPSIS
    Lists diagnostics for a stack configuration
.DESCRIPTION
    Retrieves the diagnostic messages produced when parsing/validating a stack configuration
.PARAMETER StackConfigurationId
    The stack configuration ID
.EXAMPLE
    Get-TfcStackConfigurationDiagnostic -StackConfigurationId "stackcfg-abc123"
.OUTPUTS
    PSCustomObject representing the configuration diagnostics
#>
function Get-TfcStackConfigurationDiagnostic {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackConfigurationId
    )

    Write-Verbose "Getting diagnostics for stack configuration: $StackConfigurationId"
    return Invoke-TfcApi -Uri "/stack-configurations/$StackConfigurationId/stack-diagnostics"
}
