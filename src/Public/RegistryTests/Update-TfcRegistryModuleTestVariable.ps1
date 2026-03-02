<#
.SYNOPSIS
    Updates a test variable for a registry module
.DESCRIPTION
    Updates an existing variable for testing a private registry module
.PARAMETER Organization
    The organization name
.PARAMETER ModuleName
    The module name
.PARAMETER ProviderName
    The provider name
.PARAMETER VariableId
    The variable ID to update
.PARAMETER Key
    The variable key name
.PARAMETER Value
    The variable value
.PARAMETER HCL
    Whether the value is HCL
.PARAMETER Sensitive
    Whether the variable is sensitive
.EXAMPLE
    Update-TfcRegistryModuleTestVariable -Organization "my-org" -ModuleName "vpc" -ProviderName "aws" -VariableId "var-abc123" -Value "us-west-2"
.OUTPUTS
    PSCustomObject representing the updated variable
#>
function Update-TfcRegistryModuleTestVariable {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$ModuleName,

        [Parameter(Mandatory = $true)]
        [string]$ProviderName,

        [Parameter(Mandatory = $true)]
        [string]$VariableId,

        [Parameter(Mandatory = $false)]
        [string]$Key,

        [Parameter(Mandatory = $false)]
        [string]$Value,

        [Parameter(Mandatory = $false)]
        [Nullable[bool]]$HCL,

        [Parameter(Mandatory = $false)]
        [Nullable[bool]]$Sensitive
    )

    $uri = "/organizations/$Organization/tests/registry-modules/private/$Organization/$ModuleName/$ProviderName/vars/$VariableId"

    $attributes = @{}
    if ($PSBoundParameters.ContainsKey('Key')) { $attributes['key'] = $Key }
    if ($PSBoundParameters.ContainsKey('Value')) { $attributes['value'] = $Value }
    if ($PSBoundParameters.ContainsKey('HCL')) { $attributes['hcl'] = $HCL }
    if ($PSBoundParameters.ContainsKey('Sensitive')) { $attributes['sensitive'] = $Sensitive }

    $body = @{
        data = @{
            type       = "vars"
            id         = $VariableId
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Updating test variable '$VariableId' for module: $Organization/$ModuleName/$ProviderName"
    if ($PSCmdlet.ShouldProcess("Variable '$VariableId' for module '$Organization/$ModuleName/$ProviderName'", "Update test variable")) {
        return Invoke-TfcApi -Uri $uri -Method PATCH -Body $body
    }
}
