<#
.SYNOPSIS
    Deletes a plan export
.DESCRIPTION
    Removes a specific plan export by ID
.PARAMETER PlanExportId
    The plan export ID to delete
.EXAMPLE
    Remove-TfcPlanExport -PlanExportId "pe-abc123"
.OUTPUTS
    None
#>
function Remove-TfcPlanExport {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PlanExportId
    )

    if ($PSCmdlet.ShouldProcess("Plan export $PlanExportId", "Delete")) {
        Write-Verbose "Deleting plan export: $PlanExportId"
        return Invoke-TfcApi -Uri "/plan-exports/$PlanExportId" -Method DELETE
    }
}
