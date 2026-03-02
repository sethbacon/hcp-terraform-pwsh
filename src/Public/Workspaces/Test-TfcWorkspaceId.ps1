<#
.SYNOPSIS
    Tests if a workspace ID is valid
.DESCRIPTION
    Validates the format of a Terraform Cloud workspace ID
.PARAMETER WorkspaceId
    The workspace ID to validate
.EXAMPLE
    Test-TfcWorkspaceId -WorkspaceId "ws-1234567890abcdef"
.OUTPUTS
    Boolean indicating whether the workspace ID format is valid
#>
function Test-TfcWorkspaceId {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId
    )

    return Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId
}
