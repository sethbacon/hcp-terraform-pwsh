<#
.SYNOPSIS
    Gets SSH keys for an organization
.DESCRIPTION
    Retrieves SSH keys used for accessing private Git repositories
.PARAMETER Organization
    The organization name
.EXAMPLE
    Get-TfcSSHKey -Organization "my-org"
.OUTPUTS
    PSCustomObject representing SSH keys
#>
function Get-TfcSSHKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization
    )

    Write-Verbose "Getting SSH keys for organization: $Organization"
    return Invoke-TfcApi -Uri "/organizations/$Organization/ssh-keys"
}
