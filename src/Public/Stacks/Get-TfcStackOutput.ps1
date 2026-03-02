<#
.SYNOPSIS
    Get stack outputs
.DESCRIPTION
    Retrieves the outputs from a stack
.PARAMETER StackId
    The ID of the stack
.EXAMPLE
    Get-TfcStackOutput -StackId "stack-123"
.OUTPUTS
    PSCustomObject representing stack outputs
#>
function Get-TfcStackOutput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId
    )

    try {
        Initialize-TfcConnection
        Write-Verbose "Getting outputs for stack: $StackId"
        return Invoke-TfcApi -Uri "/stacks/$StackId/outputs" -Method GET
    }
    catch {
        throw "Failed to get stack outputs: $($_.Exception.Message)"
    }
}
