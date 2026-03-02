<#
.SYNOPSIS
    Get detailed VCS event information
.DESCRIPTION
    Retrieves detailed information about a specific VCS event
.PARAMETER VCSEventId
    The ID of the VCS event (format: vcsev-xxxxx)
.EXAMPLE
    Get-TfcVCSEventDetails -VCSEventId vcsev-abc123
#>
function Get-TfcVCSEventDetails {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VCSEventId
    )

    Initialize-TfcConnection
    Write-Verbose "Getting detailed information for VCS event: $VCSEventId"
    return Invoke-TfcApi -Uri "/vcs-events/$VCSEventId" -Method GET
}
