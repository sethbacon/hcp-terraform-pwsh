<#
.SYNOPSIS
    Removes a variable from a workspace
.DESCRIPTION
    Deletes a variable from a Terraform Cloud workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER Key
    The variable name/key to remove
.EXAMPLE
    Remove-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "old_variable"
.OUTPUTS
    None
#>
function Remove-TfcWorkspaceVariable {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$Key
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    # First, get the variable ID
    $vars = Get-TfcWorkspaceVariable -WorkspaceId $WorkspaceId
    $variable = $vars.data | Where-Object { $_.attributes.key -eq $Key }

    if (-not $variable) {
        throw "Variable '$Key' not found in workspace $WorkspaceId"
    }

    if ($PSCmdlet.ShouldProcess("Variable '$Key' in workspace $WorkspaceId", "Remove")) {
        Write-Verbose "Removing variable '$Key' from workspace: $WorkspaceId"
        Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/vars/$($variable.id)" -Method DELETE | Out-Null
        return $true
    }
}
