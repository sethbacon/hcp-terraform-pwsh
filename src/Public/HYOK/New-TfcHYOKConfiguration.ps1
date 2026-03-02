<#
.SYNOPSIS
    Creates a new HYOK configuration
.DESCRIPTION
    Creates a new Hold Your Own Key (HYOK) configuration for the specified organization
.PARAMETER Organization
    The name of the organization
.PARAMETER Name
    The name of the HYOK configuration
.PARAMETER KeyProviderId
    The ID of the key provider
.PARAMETER KeyName
    The name of the encryption key
.PARAMETER KeyVersion
    The version of the encryption key (optional)
.EXAMPLE
    New-TfcHYOKConfiguration -Organization "my-org" -Name "prod-key" -KeyProviderId "kp-abc123" -KeyName "my-key"
.EXAMPLE
    New-TfcHYOKConfiguration -Organization "my-org" -Name "prod-key" -KeyProviderId "kp-abc123" -KeyName "my-key" -KeyVersion "1"
.OUTPUTS
    PSCustomObject representing the created HYOK configuration
#>
function New-TfcHYOKConfiguration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$KeyProviderId,

        [Parameter(Mandatory = $true)]
        [string]$KeyName,

        [Parameter(Mandatory = $false)]
        [string]$KeyVersion
    )

    $attributes = @{
        name             = $Name
        'key-provider-id' = $KeyProviderId
        'key-name'       = $KeyName
    }

    if ($KeyVersion) {
        $attributes['key-version'] = $KeyVersion
    }

    $body = @{
        data = @{
            type       = "hyok-configurations"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating HYOK configuration '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create HYOK configuration: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/hyok-configurations" -Method POST -Body $body
    }
}
