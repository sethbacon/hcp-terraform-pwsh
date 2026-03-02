<#
.SYNOPSIS
    Creates an SSH key
.DESCRIPTION
    Uploads an SSH private key for accessing private Git repositories
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The SSH key name
.PARAMETER Value
    The SSH private key content
.EXAMPLE
    $sshKey = Get-Content ~/.ssh/id_rsa -Raw
    New-TfcSSHKey -Organization "my-org" -Name "GitHub Key" -Value $sshKey
.OUTPUTS
    PSCustomObject representing the created SSH key
#>
function New-TfcSSHKey {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $body = @{
        data = @{
            type = "ssh-keys"
            attributes = @{
                name = $Name
                value = $Value
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating SSH key '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create SSH key: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/ssh-keys" -Method POST -Body $body
    }
}
