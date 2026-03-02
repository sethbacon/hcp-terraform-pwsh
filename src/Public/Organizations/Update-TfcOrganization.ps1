<#
.SYNOPSIS
    Updates an existing organization
.DESCRIPTION
    Updates properties of an existing organization
.PARAMETER Organization
    The organization name
.PARAMETER Email
    New admin email address (optional)
.PARAMETER SessionTimeout
    New session timeout in minutes (optional)
.PARAMETER SessionRemember
    New session remember duration in minutes (optional)
.PARAMETER CollaboratorAuthPolicy
    New authentication policy (optional)
.EXAMPLE
    Update-TfcOrganization -Organization "my-org" -Email "newemail@example.com"
.OUTPUTS
    PSCustomObject representing the updated organization
#>
function Update-TfcOrganization {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter()]
        [string]$Email,

        [Parameter()]
        [int]$SessionTimeout,

        [Parameter()]
        [int]$SessionRemember,

        [Parameter()]
        [ValidateSet('password', 'two_factor_mandatory')]
        [string]$CollaboratorAuthPolicy
    )

    $attributes = @{}

    if ($PSBoundParameters.ContainsKey('Email')) {
        $attributes['email'] = $Email
    }

    if ($PSBoundParameters.ContainsKey('SessionTimeout')) {
        $attributes['session-timeout'] = $SessionTimeout
    }

    if ($PSBoundParameters.ContainsKey('SessionRemember')) {
        $attributes['session-remember'] = $SessionRemember
    }

    if ($PSBoundParameters.ContainsKey('CollaboratorAuthPolicy')) {
        $attributes['collaborator-auth-policy'] = $CollaboratorAuthPolicy
    }

    if ($attributes.Count -eq 0) {
        Write-Error "At least one attribute must be specified for update"
        return
    }

    $body = @{
        data = @{
            type = "organizations"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Update organization settings")) {
        Write-Verbose "Updating organization: $Organization"
        return Invoke-TfcApi -Uri "/organizations/$Organization" -Method PATCH -Body $body
    }
}
