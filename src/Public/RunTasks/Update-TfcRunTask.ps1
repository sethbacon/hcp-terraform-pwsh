<#
.SYNOPSIS
    Updates a run task
.DESCRIPTION
    Updates an existing run task
.PARAMETER RunTaskId
    The run task ID
.PARAMETER Name
    New name for the task
.PARAMETER Url
    New URL for the task
.PARAMETER HmacKey
    New HMAC key
.PARAMETER Enabled
    Whether the task is enabled
.PARAMETER Description
    New description
.EXAMPLE
    Update-TfcRunTask -RunTaskId "task-abc123" -Enabled $false
.OUTPUTS
    PSCustomObject representing the updated run task
#>
function Update-TfcRunTask {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$RunTaskId,

        [Parameter(Mandatory = $false)]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string]$HmacKey,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    $attributes = @{}

    if ($PSBoundParameters.ContainsKey('Name')) { $attributes['name'] = $Name }
    if ($PSBoundParameters.ContainsKey('Url')) { $attributes['url'] = $Url }
    if ($PSBoundParameters.ContainsKey('HmacKey')) { $attributes['hmac-key'] = $HmacKey }
    if ($PSBoundParameters.ContainsKey('Enabled')) { $attributes['enabled'] = $Enabled }
    if ($PSBoundParameters.ContainsKey('Description')) { $attributes['description'] = $Description }

    if ($attributes.Count -eq 0) {
        throw "At least one attribute must be specified for update"
    }

    $body = @{
        data = @{
            type = "tasks"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating run task: $RunTaskId"
    if ($PSCmdlet.ShouldProcess("Run Task: $RunTaskId", "Update run task")) {
        return Invoke-TfcApi -Uri "/tasks/$RunTaskId" -Method PATCH -Body $body
    }
}
