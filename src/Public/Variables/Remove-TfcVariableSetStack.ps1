<#
.SYNOPSIS
    Removes a variable set from stack(s)
.DESCRIPTION
    Removes a variable set assignment from one or more stacks
.PARAMETER VariableSetId
    The variable set ID
.PARAMETER StackIds
    Array of stack IDs to remove the variable set from
.EXAMPLE
    Remove-TfcVariableSetStack -VariableSetId "varset-abc123" -StackIds @("stack-123", "stack-456")
.OUTPUTS
    Boolean indicating success
#>
function Remove-TfcVariableSetStack {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,

        [Parameter(Mandatory = $true)]
        [string[]]$StackIds
    )

    if ($PSCmdlet.ShouldProcess("$($StackIds.Count) stack(s)", "Remove variable set assignment")) {
        $stackData = $StackIds | ForEach-Object {
            @{
                type = "stacks"
                id = $_
            }
        }

        $body = @{
            data = $stackData
        } | ConvertTo-Json -Depth 10

        Write-Verbose "Removing variable set $VariableSetId from $($StackIds.Count) stack(s)"
        try {
            Invoke-TfcApi -Uri "/varsets/$VariableSetId/relationships/stacks" -Method DELETE -Body $body
            return $true
        }
        catch {
            Write-Error "Failed to remove variable set from stacks: $_"
            return $false
        }
    }
}
