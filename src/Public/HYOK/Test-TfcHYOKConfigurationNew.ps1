<#
.SYNOPSIS
    Tests an unpersisted HYOK configuration
.DESCRIPTION
    Tests connectivity for a Hold Your Own Key (HYOK) configuration before saving it.
    This allows validating the configuration parameters without creating the resource.
.PARAMETER Organization
    The name of the organization
.PARAMETER KeyProviderId
    The ID of the key provider
.PARAMETER KeyName
    The name of the encryption key
.PARAMETER KeyVersion
    The version of the encryption key (optional)
.EXAMPLE
    Test-TfcHYOKConfigurationNew -Organization "my-org" -KeyProviderId "kp-abc123" -KeyName "my-key"
.EXAMPLE
    Test-TfcHYOKConfigurationNew -Organization "my-org" -KeyProviderId "kp-abc123" -KeyName "my-key" -KeyVersion "1"
.OUTPUTS
    PSCustomObject representing the test result
#>
function Test-TfcHYOKConfigurationNew {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$KeyProviderId,

        [Parameter(Mandatory = $true)]
        [string]$KeyName,

        [Parameter(Mandatory = $false)]
        [string]$KeyVersion
    )

    $attributes = @{
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

    Write-Verbose "Testing unpersisted HYOK configuration for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/hyok-configurations/test" -Method POST -Body $body
}
