# Mock Data for State Version Tests
# Provides consistent test data for state operations

function Get-MockStateVersion {
    param(
        [string]$Id = "sv-$(New-Guid)",
        [string]$WorkspaceId = "ws-123",
        [int]$Serial = 1,
        [bool]$Locked = $false,
        [int]$ResourcesProcessed = 10
    )

    return @{
        id = $Id
        type = 'state-versions'
        attributes = @{
            serial = $Serial
            'resources-processed' = $ResourcesProcessed
            'created-at' = '2025-01-15T12:00:00.000Z'
            'hosted-state-download-url' = "https://example.com/state/$Id/download"
            locked = $Locked
        }
        relationships = @{
            workspace = @{
                data = @{
                    id = $WorkspaceId
                    type = 'workspaces'
                }
            }
            outputs = @{
                data = @()
            }
        }
    }
}

function Get-MockStateVersionOutput {
    param(
        [string]$Id = "wsout-$(New-Guid)",
        [string]$Name = "output_name",
        [string]$Value = "output_value",
        [bool]$Sensitive = $false
    )

    return @{
        id = $Id
        type = 'state-version-outputs'
        attributes = @{
            name = $Name
            value = if ($Sensitive) { $null } else { $Value }
            sensitive = $Sensitive
            type = 'string'
        }
    }
}

function Get-MockStateFile {
    param(
        [string]$Version = "4",
        [int]$Serial = 1
    )

    return @{
        version = [int]$Version
        terraform_version = "1.5.0"
        serial = $Serial
        lineage = "$(New-Guid)"
        outputs = @{}
        resources = @()
    }
}

Export-ModuleMember -Function @(
    'Get-MockStateVersion',
    'Get-MockStateVersionOutput',
    'Get-MockStateFile'
)
