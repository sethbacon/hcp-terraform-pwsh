<#
.SYNOPSIS
    Creates a comment on a run
.DESCRIPTION
    Adds a comment to a Terraform run for collaboration
.PARAMETER RunId
    The run ID
.PARAMETER Body
    The comment text
.EXAMPLE
    New-TfcComment -RunId "run-123" -Body "Approved for production deployment"
.OUTPUTS
    PSCustomObject representing the created comment
#>
function New-TfcComment {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunId,
        [Parameter(Mandatory = $true)]
        [string]$Body
    )

    Initialize-TfcConnection

    $requestBody = @{
        data = @{
            type = "comments"
            attributes = @{
                body = $Body
            }
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Run '$RunId'", "Add comment")) {
        Write-Verbose "Adding comment to run: $RunId"
        return Invoke-TfcApi -Uri "/runs/$RunId/comments" -Method POST -Body $requestBody
    }
}
