<#
.SYNOPSIS
    Gets JSON output of an assessment result
.DESCRIPTION
    Retrieves the JSON output for a specific assessment result
.PARAMETER AssessmentResultId
    The assessment result ID
.EXAMPLE
    Get-TfcAssessmentResultJsonOutput -AssessmentResultId "asmtresult-abc123"
.OUTPUTS
    PSCustomObject representing the assessment result JSON output
#>
function Get-TfcAssessmentResultJsonOutput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AssessmentResultId
    )

    Write-Verbose "Getting assessment result JSON output: $AssessmentResultId"
    return Invoke-TfcApi -Uri "/assessment-results/$AssessmentResultId/json-output"
}
