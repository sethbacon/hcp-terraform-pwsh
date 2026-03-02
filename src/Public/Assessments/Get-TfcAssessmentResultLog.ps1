<#
.SYNOPSIS
    Gets log output of an assessment result
.DESCRIPTION
    Retrieves the log output for a specific assessment result
.PARAMETER AssessmentResultId
    The assessment result ID
.EXAMPLE
    Get-TfcAssessmentResultLog -AssessmentResultId "asmtresult-abc123"
.OUTPUTS
    String representing the assessment result log output
#>
function Get-TfcAssessmentResultLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AssessmentResultId
    )

    Write-Verbose "Getting assessment result log: $AssessmentResultId"
    return Invoke-TfcApi -Uri "/assessment-results/$AssessmentResultId/log-output"
}
