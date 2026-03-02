<#
.SYNOPSIS
    Update stack configuration
.DESCRIPTION
    Updates the configuration for a stack
.PARAMETER StackId
    The ID of the stack
.PARAMETER ConfigurationData
    The configuration data as a hashtable
.EXAMPLE
    Update-TfcStackConfiguration -StackId "stack-123" -ConfigurationData @{key="value"}
.OUTPUTS
    PSCustomObject representing updated configuration
#>
function Update-TfcStackConfiguration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId,

        [Parameter(Mandatory = $true)]
        [hashtable]$ConfigurationData
    )

    try {
        Initialize-TfcConnection

        $body = @{
            data = @{
                type = "stack-configurations"
                attributes = $ConfigurationData
            }
        } | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess("Stack: $StackId", "Update configuration")) {
            Write-Verbose "Updating configuration for stack: $StackId"
            return Invoke-TfcApi -Uri "/stacks/$StackId/configuration" -Method PATCH -Body $body
        }
    }
    catch {
        throw "Failed to update stack configuration: $($_.Exception.Message)"
    }
}
