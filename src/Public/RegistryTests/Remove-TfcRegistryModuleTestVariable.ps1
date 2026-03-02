<#
.SYNOPSIS
    Deletes a test variable for a registry module
.DESCRIPTION
    Removes a variable from a private registry module's test configuration
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.PARAMETER VariableId
    The variable ID to delete
.EXAMPLE
    Remove-TfcRegistryModuleTestVariable -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -VariableId "var-abc123"
.OUTPUTS
    None
#>
function Remove-TfcRegistryModuleTestVariable {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ProviderName,

        [Parameter(Mandatory = $true)]
        [string]$VariableId
    )

    if ($PSCmdlet.ShouldProcess("Test variable $VariableId", "Delete")) {
        $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/vars/$VariableId"
        Write-Verbose "Deleting test variable '$VariableId' for module: $Organization/$ModuleName/$ProviderName"
        return Invoke-TfcApi -Uri $uri -Method DELETE
    }
}
