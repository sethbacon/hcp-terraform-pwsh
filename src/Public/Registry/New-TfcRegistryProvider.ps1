<#
.SYNOPSIS
    Creates a registry provider
.DESCRIPTION
    Creates a new registry provider in Terraform Cloud
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The provider name
.PARAMETER RegistryName
    The registry name (default: "private")
.EXAMPLE
    New-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
.OUTPUTS
    PSCustomObject representing the created registry provider
#>
function New-TfcRegistryProvider {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$RegistryName = "private"
    )

    $body = @{
        data = @{
            type = "registry-providers"
            attributes = @{
                name = $Name
                namespace = $Organization
                "registry-name" = $RegistryName
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating registry provider '$Name' in organization: $Organization"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create registry provider: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/registry-providers" -Method POST -Body $body
    }
}
