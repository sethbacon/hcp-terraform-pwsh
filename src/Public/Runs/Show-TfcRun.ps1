<#
.SYNOPSIS
    Shows detailed run information with relationships
.DESCRIPTION
    Retrieves detailed information about a run including optional relationships
.PARAMETER RunId
    The ID of the run
.PARAMETER Include
    Optional array of relationships to include (plan, apply, workspace, configuration-version, etc.)
.EXAMPLE
    Show-TfcRun -RunId "run-123"
.EXAMPLE
    Show-TfcRun -RunId "run-123" -Include @('plan', 'apply', 'workspace')
.OUTPUTS
    PSCustomObject representing the run with included relationships
#>
function Show-TfcRun {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,

        [Parameter(Mandatory = $false)]
        [ValidateSet('plan', 'apply', 'configuration-version', 'created-by', 'workspace', 'task-stages', 'policy-checks', 'run-events')]
        [string[]]$Include
    )

    $uri = "/runs/$RunId"

    if ($Include) {
        $includeParam = $Include -join ','
        $uri += "?include=$includeParam"
        Write-Verbose "Retrieving run $RunId with relationships: $includeParam"
    } else {
        Write-Verbose "Retrieving run: $RunId"
    }

    return Invoke-TfcApi -Uri $uri
}
