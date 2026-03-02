<#
.SYNOPSIS
    Assigns an SSH key to a workspace
.DESCRIPTION
    Associates an SSH key with a workspace for VCS repository access
.PARAMETER Organization
    The organization name
.PARAMETER WorkspaceName
    The workspace name
.PARAMETER SSHKeyId
    The SSH key ID to assign
.EXAMPLE
    Set-TfcWorkspaceSSHKey -Organization "my-org" -WorkspaceName "my-workspace" -SSHKeyId "sshkey-abc123"
.OUTPUTS
    PSCustomObject representing the updated workspace
#>
function Set-TfcWorkspaceSSHKey {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$WorkspaceName,

        [Parameter(Mandatory = $false)]
        [AllowEmptyString()]
        [string]$SSHKeyId = $null
    )

    $sshKeyValue = if ([string]::IsNullOrEmpty($SSHKeyId)) { $null } else { $SSHKeyId }

    $body = @{
        data = @{
            type = "workspaces"
            attributes = @{
                'vcs-repo' = @{
                    'ssh-key-id' = $sshKeyValue
                }
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Assigning SSH key $SSHKeyId to workspace $WorkspaceName"
    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceName", "Assign SSH key")) {
        # First get the workspace to get its ID
        $workspace = Get-TfcWorkspace -Organization $Organization -Name $WorkspaceName
        return Invoke-TfcApi -Uri "/workspaces/$($workspace.data.id)/relationships/ssh-key" -Method PATCH -Body $body
    }
}
