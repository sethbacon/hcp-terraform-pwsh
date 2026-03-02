<#
.SYNOPSIS
    Updates the current user account
.DESCRIPTION
    Updates account details for the currently authenticated user
.PARAMETER Username
    New username
.PARAMETER Email
    New email address
.EXAMPLE
    Update-TfcAccount -Username "newusername" -Email "new@example.com"
.OUTPUTS
    PSCustomObject representing the updated account
#>
function Update-TfcAccount {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $false)]
        [string]$Username,

        [Parameter(Mandatory = $false)]
        [string]$Email
    )

    $attributes = @{}
    if ($PSBoundParameters.ContainsKey('Username')) { $attributes['username'] = $Username }
    if ($PSBoundParameters.ContainsKey('Email')) { $attributes['email'] = $Email }

    $body = @{
        data = @{
            type       = "users"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 5

    Write-Verbose "Updating account details"
    if ($PSCmdlet.ShouldProcess("Current user account", "Update account details")) {
        return Invoke-TfcApi -Uri "/account/update" -Method PATCH -Body $body
    }
}
