<#
.SYNOPSIS
    Get stack resources
.DESCRIPTION
    Retrieves resources managed by a stack
.PARAMETER StackId
    The ID of the stack
.EXAMPLE
    Get-TfcStackResource -StackId "stack-123"
.OUTPUTS
    PSCustomObject representing stack resources
#>
function Get-TfcStackResource {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId
    )

    try {
        Initialize-TfcConnection
        Write-Verbose "Getting resources for stack: $StackId"
        return Invoke-TfcApi -Uri "/stacks/$StackId/resources" -Method GET
    }
    catch {
        throw "Failed to get stack resources: $($_.Exception.Message)"
    }
}
