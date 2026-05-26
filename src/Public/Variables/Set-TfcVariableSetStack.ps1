<#
.SYNOPSIS
    Assigns a variable set to stack(s)
.DESCRIPTION
    Adds a variable set to one or more stacks
.PARAMETER VariableSetId
    The variable set ID
.PARAMETER StackIds
    Array of stack IDs to assign the variable set to
.EXAMPLE
    Set-TfcVariableSetStack -VariableSetId "varset-abc123" -StackIds @("stack-123", "stack-456")
.OUTPUTS
    Boolean indicating success
#>
function Set-TfcVariableSetStack {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,

        [Parameter(Mandatory = $true)]
        [string[]]$StackIds
    )

    $stackData = $StackIds | ForEach-Object {
        @{
            type = "stacks"
            id = $_
        }
    }

    $body = @{
        data = $stackData
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Assigning variable set $VariableSetId to $($StackIds.Count) stack(s)"
    try {
        Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/stacks" -Method POST -Body $body
        return $true
    }
    catch {
        Write-Error "Failed to assign variable set to stacks: $_"
        return $false
    }
}
