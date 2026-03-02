<#
.SYNOPSIS
    Creates a new variable set
.DESCRIPTION
    Creates a new variable set in a Terraform Cloud organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The variable set name
.PARAMETER Description
    Optional description for the variable set
.PARAMETER Global
    Whether this variable set should be applied to all workspaces
.PARAMETER Priority
    Whether variable set variables override workspace variables (optional)
.EXAMPLE
    New-TfcVariableSet -Organization "my-org" -Name "aws-creds"
.EXAMPLE
    New-TfcVariableSet -Organization "my-org" -Name "global-vars" -Global -Description "Global variables"
.OUTPUTS
    PSCustomObject representing the created variable set
#>
function New-TfcVariableSet {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [switch]$Global,

        [switch]$Priority
    )

    $attributes = @{
        name = $Name
        global = $Global.IsPresent
    }

    if ($PSBoundParameters.ContainsKey('Description')) {
        $attributes["description"] = $Description
    }

    if ($PSBoundParameters.ContainsKey('Priority')) {
        $attributes["priority"] = $Priority.IsPresent
    }

    $body = @{
        data = @{
            type = "varsets"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating variable set: $Name in organization: $Organization"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create variable set: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/varsets" -Method POST -Body $body
    }
}
