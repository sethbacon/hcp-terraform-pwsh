<#
.SYNOPSIS
    Delete a stack
.DESCRIPTION
    Removes a stack from the organization
.PARAMETER StackId
    The ID of the stack to delete
.PARAMETER Force
    Skip confirmation prompt
.EXAMPLE
    Remove-TfcStack -StackId "stack-123"
.EXAMPLE
    Remove-TfcStack -StackId "stack-123" -Force
#>
function Remove-TfcStack {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId,

        [Parameter(Mandatory = $false)]
        [switch]$Force
    )

    try {
        Initialize-TfcConnection

        if ($Force -or $PSCmdlet.ShouldProcess("Stack: $StackId", "Delete stack")) {
            Write-Verbose "Deleting stack: $StackId"
            return Invoke-TfcApi -Uri "/stacks/$StackId" -Method DELETE
        }
    }
    catch {
        throw "Failed to delete stack: $($_.Exception.Message)"
    }
}
