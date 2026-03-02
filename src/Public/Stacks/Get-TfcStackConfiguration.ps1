<#
.SYNOPSIS
    Get stack configuration
.DESCRIPTION
    Retrieves the configuration for a stack
.PARAMETER StackId
    The ID of the stack
.EXAMPLE
    Get-TfcStackConfiguration -StackId "stack-123"
.OUTPUTS
    PSCustomObject representing stack configuration
#>
function Get-TfcStackConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId
    )

    try {
        Initialize-TfcConnection
        Write-Verbose "Getting configuration for stack: $StackId"
        return Invoke-TfcApi -Uri "/stacks/$StackId/configuration" -Method GET
    }
    catch {
        throw "Failed to get stack configuration: $($_.Exception.Message)"
    }
}
