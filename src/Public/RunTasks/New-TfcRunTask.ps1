<#
.SYNOPSIS
    Creates a run task
.DESCRIPTION
    Creates a new run task in an organization
.PARAMETER Organization
    The organization name
.PARAMETER Name
    The run task name
.PARAMETER Url
    The URL of the external service to call
.PARAMETER HmacKey
    Optional HMAC key for request signing
.PARAMETER Enabled
    Whether the task is enabled (default: true)
.PARAMETER Description
    Optional description
.EXAMPLE
    New-TfcRunTask -Organization "my-org" -Name "security-scan" -Url "https://scanner.example.com/validate"
.OUTPUTS
    PSCustomObject representing the created run task
#>
function New-TfcRunTask {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Organization,

        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Url,

        [Parameter(Mandatory = $false)]
        [string]$HmacKey,

        [Parameter(Mandatory = $false)]
        [bool]$Enabled = $true,

        [Parameter(Mandatory = $false)]
        [string]$Description
    )

    $attributes = @{
        name = $Name
        url = $Url
        enabled = $Enabled
    }

    if ($HmacKey) {
        $attributes['hmac-key'] = $HmacKey
    }

    if ($Description) {
        $attributes['description'] = $Description
    }

    $body = @{
        data = @{
            type = "tasks"
            attributes = $attributes
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Creating run task '$Name' in organization '$Organization'"
    if ($PSCmdlet.ShouldProcess("Organization: $Organization", "Create run task: $Name")) {
        return Invoke-TfcApi -Uri "/organizations/$Organization/tasks" -Method POST -Body $body
    }
}
