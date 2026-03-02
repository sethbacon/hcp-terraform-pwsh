<#
.SYNOPSIS
    Updates an existing variable set
.DESCRIPTION
    Updates properties of an existing variable set
.PARAMETER VariableSetId
    The variable set ID
.PARAMETER Name
    New name for the variable set (optional)
.PARAMETER Description
    New description for the variable set (optional)
.PARAMETER Global
    Whether this variable set should be applied to all workspaces (optional)
.PARAMETER Priority
    Whether variable set variables override workspace variables (optional)
.EXAMPLE
    Update-TfcVariableSet -VariableSetId "varset-abc123" -Name "new-name"
.EXAMPLE
    Update-TfcVariableSet -VariableSetId "varset-abc123" -Global:$false
.OUTPUTS
    PSCustomObject representing the updated variable set
#>
function Update-TfcVariableSet {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$VariableSetId,

        [Parameter()]
        [string]$Name,

        [Parameter()]
        [string]$Description,

        [Parameter()]
        [bool]$Global,

        [Parameter()]
        [bool]$Priority
    )

    $attributes = @{}

    if ($PSBoundParameters.ContainsKey('Name')) {
        $attributes["name"] = $Name
    }

    if ($PSBoundParameters.ContainsKey('Description')) {
        $attributes["description"] = $Description
    }

    if ($PSBoundParameters.ContainsKey('Global')) {
        $attributes["global"] = $Global
    }

    if ($PSBoundParameters.ContainsKey('Priority')) {
        $attributes["priority"] = $Priority
    }

    if ($attributes.Count -eq 0) {
        Write-Error "At least one attribute must be specified for update"
        return
    }

    $body = @{
        data = @{
            type = "varsets"
            id = $VariableSetId
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating variable set: $VariableSetId"
    if ($PSCmdlet.ShouldProcess("Variable Set: $VariableSetId", "Update variable set")) {
        return Invoke-TfcApi -Uri "/varsets/$VariableSetId" -Method PATCH -Body $body
    }
}
