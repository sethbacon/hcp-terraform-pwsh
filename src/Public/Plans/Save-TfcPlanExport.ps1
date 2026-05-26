<#
.SYNOPSIS
    Downloads a plan export
.DESCRIPTION
    Downloads the exported plan data for a specific plan export
.PARAMETER PlanExportId
    The plan export ID
.PARAMETER OutputPath
    The file path to save the downloaded export
.EXAMPLE
    Save-TfcPlanExport -PlanExportId "pe-abc123" -OutputPath "./plan-export.tar.gz"
.OUTPUTS
    Boolean indicating success or failure
#>
function Save-TfcPlanExport {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$PlanExportId,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )

    try {
        Initialize-TfcConnection
        $fullUri = "$script:TfcApiBaseUri/plan-exports/$PlanExportId/download"
        Write-Verbose "Downloading plan export: $PlanExportId to $OutputPath"
        Invoke-RestMethod -Uri $fullUri -Method GET -Headers $script:TfcHeaders -Authentication Bearer -Token $script:TfcToken -OutFile $OutputPath
        return $true
    }
    catch {
        Write-Error "Failed to download plan export: $_"
        return $false
    }
}
