<#
.SYNOPSIS
    Gets a plan export
.DESCRIPTION
    Retrieves details of a plan export and optionally downloads it
.PARAMETER PlanExportId
    The plan export ID
.PARAMETER OutputPath
    Optional path to save the export file
.EXAMPLE
    Get-TfcPlanExport -PlanExportId "pe-abc123" -OutputPath "./plan-export.tar.gz"
.OUTPUTS
    PSCustomObject representing the plan export
#>
function Get-TfcPlanExport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PlanExportId,

        [Parameter(Mandatory = $false)]
        [string]$OutputPath
    )

    Write-Verbose "Getting plan export: $PlanExportId"
    $export = Invoke-TfcApi -Uri "/plan-exports/$PlanExportId"

    if ($OutputPath -and $export.data.attributes.'download-url') {
        $downloadUrl = $export.data.attributes.'download-url'
        Write-Verbose "Downloading plan export to: $OutputPath"

        try {
            Invoke-WebRequest -Uri $downloadUrl -OutFile $OutputPath
            Write-Output "Plan export downloaded to: $OutputPath"
        }
        catch {
            Write-Error "Failed to download plan export: $($_.Exception.Message)"
        }
    }

    return $export
}
