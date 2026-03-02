# Mock Data for Workspace-related Tests
# Provides consistent test data for workspace operations

function Get-MockWorkspace {
    param(
        [string]$Id = "ws-$(New-Guid)",
        [string]$Name = "test-workspace",
        [string]$Organization = "test-org",
        [int]$ResourceCount = 0,
        [bool]$Locked = $false,
        [bool]$AutoApply = $false
    )

    return @{
        id = $Id
        type = 'workspaces'
        attributes = @{
            name = $Name
            'auto-apply' = $AutoApply
            'terraform-version' = '1.5.0'
            'resource-count' = $ResourceCount
            locked = $Locked
            'execution-mode' = 'remote'
            'working-directory' = ''
            'vcs-repo' = $null
            description = "Test workspace for $Name"
            'created-at' = '2025-01-01T00:00:00.000Z'
            'updated-at' = '2025-01-15T12:00:00.000Z'
            permissions = @{
                'can-update' = $true
                'can-destroy' = $true
                'can-queue-run' = $true
                'can-lock' = $true
            }
        }
        relationships = @{
            organization = @{
                data = @{
                    id = $Organization
                    type = 'organizations'
                }
            }
            'current-run' = @{
                data = $null
            }
            'latest-run' = @{
                data = $null
            }
        }
    }
}

function Get-MockWorkspaceList {
    param(
        [int]$Count = 3,
        [string]$Organization = "test-org"
    )

    $workspaces = @()
    for ($i = 1; $i -le $Count; $i++) {
        $workspaces += Get-MockWorkspace -Name "workspace-$i" -Organization $Organization
    }

    return @{
        data = $workspaces
        meta = @{
            pagination = @{
                'current-page' = 1
                'total-pages' = 1
                'total-count' = $Count
            }
        }
    }
}

function Get-MockWorkspaceVariable {
    param(
        [string]$Id = "var-$(New-Guid)",
        [string]$Key = "test_variable",
        [string]$Value = "test_value",
        [string]$Category = 'terraform',
        [bool]$Sensitive = $false,
        [bool]$Hcl = $false
    )

    return @{
        id = $Id
        type = 'vars'
        attributes = @{
            key = $Key
            value = if ($Sensitive) { $null } else { $Value }
            sensitive = $Sensitive
            category = $Category
            hcl = $Hcl
            description = "Test variable for $Key"
        }
    }
}

Export-ModuleMember -Function @(
    'Get-MockWorkspace',
    'Get-MockWorkspaceList',
    'Get-MockWorkspaceVariable'
)
