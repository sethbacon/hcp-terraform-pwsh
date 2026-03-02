<#
.SYNOPSIS
    Creates a new organization
.DESCRIPTION
    Creates a new organization in Terraform Cloud
.PARAMETER Name
    The organization name
.PARAMETER Email
    Admin email address for the organization
.PARAMETER SessionTimeout
    Session timeout in minutes (optional)
.PARAMETER SessionRemember
    Session remember duration in minutes (optional)
.PARAMETER CollaboratorAuthPolicy
    Authentication policy: 'password', 'two_factor_mandatory' (optional)
.EXAMPLE
    New-TfcOrganization -Name "my-new-org" -Email "admin@example.com"
.OUTPUTS
    PSCustomObject representing the created organization
#>
function New-TfcOrganization {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Email,

        [Parameter()]
        [int]$SessionTimeout,

        [Parameter()]
        [int]$SessionRemember,

        [Parameter()]
        [ValidateSet('password', 'two_factor_mandatory')]
        [string]$CollaboratorAuthPolicy
    )

    $attributes = @{
        name = $Name
        email = $Email
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

    $body = @{
        data = @{
            type = "organizations"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    if ($PSCmdlet.ShouldProcess("Organization: $Name", "Create new organization")) {
        Write-Verbose "Creating organization: $Name"
        return Invoke-TfcApi -Uri "/organizations" -Method POST -Body $body
    }
}
