<#
.SYNOPSIS
    Update a no-code module
.DESCRIPTION
    Updates a no-code module's configuration
.PARAMETER NoCodeModuleId
    The ID of the no-code module (format: ncm-xxxxx)
.PARAMETER Enabled
    Whether the module is enabled for use
.PARAMETER VersionPin
    Pin to a specific module version
.EXAMPLE
    Update-TfcNoCodeModule -NoCodeModuleId ncm-abc123 -Enabled $false
#>
function Update-TfcNoCodeModule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$NoCodeModuleId,
        [Parameter(Mandatory = $false)]
        [bool]$Enabled,
        [Parameter(Mandatory = $false)]
        [string]$VersionPin
    )

    Initialize-TfcConnection

    $body = @{
        data = @{
            type = "no-code-modules"
            attributes = @{}
        }
    }

    if ($PSBoundParameters.ContainsKey('Enabled')) {
        $body.data.attributes.enabled = $Enabled
    }

    if ($VersionPin) {
        $body.data.attributes.'version-pin' = $VersionPin
    }

    $bodyJson = $body | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("No-Code Module: $NoCodeModuleId", "Update")) {
        Write-Verbose "Updating no-code module: $NoCodeModuleId"
        return Invoke-TfcApi -Uri "/no-code-modules/$NoCodeModuleId" -Method PATCH -Body $bodyJson
    }
}
