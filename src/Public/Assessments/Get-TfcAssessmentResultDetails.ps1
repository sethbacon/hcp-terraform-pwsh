<#
.SYNOPSIS
    Get detailed assessment result information
.DESCRIPTION
    Retrieves detailed information about a specific assessment result
.PARAMETER AssessmentResultId
    The ID of the assessment result (format: asmtrs-xxxxx)
.EXAMPLE
    Get-TfcAssessmentResultDetails -AssessmentResultId asmtrs-abc123
#>
function Get-TfcAssessmentResultDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AssessmentResultId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for assessment result: $AssessmentResultId"
    return Invoke-TfcApi -Uri "/assessment-results/$AssessmentResultId" -Method GET
}
