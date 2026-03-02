<#
.SYNOPSIS
    Update registry settings for an organization
.DESCRIPTION
    Updates private registry settings for an organization
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER ModuleConsumersEnabled
    Allow other organizations to consume modules
.PARAMETER ProviderConsumersEnabled
    Allow other organizations to consume providers
.EXAMPLE
    Update-TfcRegistrySettings -OrganizationName my-org -ModuleConsumersEnabled $true
#>
function Update-TfcRegistrySettings {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $false)]
        [bool]$ModuleConsumersEnabled,
        [Parameter(Mandatory = $false)]
        [bool]$ProviderConsumersEnabled
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "registry-settings"
            attributes = @{}
        }
    }

    if ($PSBoundParameters.ContainsKey('ModuleConsumersEnabled')) {
        $body.data.attributes.'module-consumers-enabled' = $ModuleConsumersEnabled
    }

    if ($PSBoundParameters.ContainsKey('ProviderConsumersEnabled')) {
        $body.data.attributes.'provider-consumers-enabled' = $ProviderConsumersEnabled
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Organization: $OrganizationName", "Update registry settings")) {
        Write-Verbose "Updating registry settings for organization: $OrganizationName"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/registry-settings" -Method PATCH -Body $bodyJson
    }
}
