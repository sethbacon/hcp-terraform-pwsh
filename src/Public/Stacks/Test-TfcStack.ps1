<#
.SYNOPSIS
    Validate a stack
.DESCRIPTION
    Validates the configuration of a stack
.PARAMETER StackId
    The ID of the stack
.EXAMPLE
    Test-TfcStack -StackId "stack-123"
.OUTPUTS
    PSCustomObject representing validation results
#>
function Test-TfcStack {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$StackId
    )

    try {
        Initialize-TfcConnection

        $body = @{
            data = @{
                type = "stack-validations"
            }
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Validating stack: $StackId"
        return Invoke-TfcApi -Uri "/stacks/$StackId/actions/validate" -Method POST -Body $body
    }
    catch {
        throw "Failed to validate stack: $($_.Exception.Message)"
    }
}
