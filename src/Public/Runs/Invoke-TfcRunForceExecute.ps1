<#
.SYNOPSIS
    Force executes a run
.DESCRIPTION
    Forces a run to execute immediately, bypassing normal queue rules
.PARAMETER RunId
    The run ID to force execute
.EXAMPLE
    Invoke-TfcRunForceExecute -RunId "run-abc123"
.OUTPUTS
    None
#>
function Invoke-TfcRunForceExecute {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId
    )

    if ($PSCmdlet.ShouldProcess("Run $RunId", "Force Execute")) {
        Write-Verbose "Force executing run: $RunId"
        Invoke-TfcApi -Uri "/runs/$RunId/actions/force-execute" -Method POST
        Write-Output "Run $RunId has been force executed"
    }
}
