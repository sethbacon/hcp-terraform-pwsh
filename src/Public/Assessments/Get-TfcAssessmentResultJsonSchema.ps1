<#
.SYNOPSIS
    Gets JSON schema of an assessment result
.DESCRIPTION
    Retrieves the JSON schema for a specific assessment result
.PARAMETER AssessmentResultId
    The assessment result ID
.EXAMPLE
    Get-TfcAssessmentResultJsonSchema -AssessmentResultId "asmtresult-abc123"
.OUTPUTS
    PSCustomObject representing the assessment result JSON schema
#>
function Get-TfcAssessmentResultJsonSchema {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AssessmentResultId
    )

    Write-Verbose "Getting assessment result JSON schema: $AssessmentResultId"
    return Invoke-TfcApi -Uri "/assessment-results/$AssessmentResultId/json-schema"
}
