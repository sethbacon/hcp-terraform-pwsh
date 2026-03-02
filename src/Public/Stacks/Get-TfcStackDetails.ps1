<#
.SYNOPSIS
    Get details of a specific stack
.DESCRIPTION
    Retrieves detailed information about a stack including its configuration and relationships
.PARAMETER StackId
    The ID of the stack
.EXAMPLE
    Get-TfcStackDetails -StackId "stack-123"
.OUTPUTS
    PSCustomObject representing the stack
#>
function Get-TfcStackDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId
    )

    try {
        Initialize-TfcConnection
        Write-Verbose "Getting stack details: $StackId"
        return Invoke-TfcApi -Uri "/stacks/$StackId" -Method GET
    }
    catch {
        throw "Failed to get stack details: $($_.Exception.Message)"
    }
}
