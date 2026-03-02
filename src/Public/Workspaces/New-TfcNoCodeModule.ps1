<#
.SYNOPSIS
    Create a no-code module
.DESCRIPTION
    Creates a no-code module for self-service infrastructure provisioning
.PARAMETER OrganizationName
    The name of the organization
.PARAMETER RegistryModuleId
    The ID of the registry module to use
.PARAMETER Name
    The name of the no-code module
.PARAMETER Enabled
    Whether the module is enabled for use
.EXAMPLE
    New-TfcNoCodeModule -OrganizationName my-org -RegistryModuleId rm-abc123 -Name "S3 Bucket" -Enabled $true
#>
function New-TfcNoCodeModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$OrganizationName,
        [Parameter(Mandatory = $true)]
        [string]$RegistryModuleId,
        [Parameter(Mandatory = $true)]
        [string]$Name,
        [Parameter(Mandatory = $false)]
        [bool]$Enabled = $true
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "no-code-modules"
            attributes = @{
                enabled = $Enabled
            }
            relationships = @{
                "registry-module" = @{
                    data = @{
                        type = "registry-modules"
                        id = $RegistryModuleId
                    }
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Organization: $OrganizationName", "Create no-code module: $Name")) {
        Write-Verbose "Creating no-code module: $Name"
        return Invoke-TfcApi -Uri "/organizations/$OrganizationName/no-code-modules" -Method POST -Body $body
    }
}
