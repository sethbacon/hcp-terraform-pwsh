<#
.SYNOPSIS
    Validates a workspace ID format
.DESCRIPTION
    Checks if the provided workspace ID matches the expected format
#>
function Test-WorkspaceIdFormat {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    return $WorkspaceId -match '^ws-[a-zA-Z0-9-]+$'
}
