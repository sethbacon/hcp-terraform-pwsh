<#
.SYNOPSIS
    Updates a variable in a workspace
.DESCRIPTION
    Updates an existing variable in a Terraform Cloud workspace
.PARAMETER WorkspaceId
    The workspace ID
.PARAMETER Key
    The variable name/key to update
.PARAMETER Value
    The new variable value
.PARAMETER Category
    The variable category (terraform or env)
.PARAMETER HCL
    Whether the variable should be parsed as HCL
.PARAMETER Sensitive
    Whether the variable is sensitive
.PARAMETER Description
    Optional description for the variable
.EXAMPLE
    Update-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-west-2" -Category "terraform"
.OUTPUTS
    PSCustomObject representing the updated variable
#>
function Update-TfcWorkspaceVariable {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkspaceId,

        [Parameter(Mandatory = $true)]
        [string]$Key,

        [Parameter(Mandatory = $true)]
        [string]$Value,

        [Parameter(Mandatory = $true)]
        [ValidateSet('terraform', 'env')]
        [string]$Category,

        [Parameter(Mandatory = $false)]
        [switch]$HCL,

        [Parameter(Mandatory = $false)]
        [switch]$Sensitive,

        [Parameter(Mandatory = $false)]
        [string]$Description = ""
    )

    if (-not (Test-WorkspaceIdFormat -WorkspaceId $WorkspaceId)) {
        throw "Invalid workspace ID format. Expected format: ws-xxxxxxxxxx"
    }

    # First, get the variable ID
    $vars = Get-TfcWorkspaceVariable -WorkspaceId $WorkspaceId
    $variable = $vars.data | Where-Object { $_.attributes.key -eq $Key }

    if (-not $variable) {
        throw "Variable '$Key' not found in workspace $WorkspaceId"
    }

    $body = @{
        data = @{
            id = $variable.id
            type = "vars"
            attributes = @{
                key = $Key
                value = $Value
                category = $Category
                hcl = $HCL.IsPresent
                sensitive = $Sensitive.IsPresent
                description = $Description
            }
        }
    } | ConvertTo-Json -Depth 10

    Write-Verbose "Updating variable '$Key' in workspace: $WorkspaceId"
    if ($PSCmdlet.ShouldProcess("Workspace: $WorkspaceId", "Update variable: $Key")) {
        return Invoke-TfcApi -Uri "/workspaces/$WorkspaceId/vars/$VariableId" -Method PATCH -Body $body
    }
}
