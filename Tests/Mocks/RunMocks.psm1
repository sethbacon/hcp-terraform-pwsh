# Mock Data for Run-related Tests
# Provides consistent test data for run operations

function Get-MockRun {
    param(
        [string]$Id = "run-$(New-Guid)",
        [string]$WorkspaceId = "ws-123",
        [string]$Status = "pending",
        [string]$Message = "Test run"
    )

    return @{
        id = $Id
        type = 'runs'
        attributes = @{
            status = $Status
            'status-timestamps' = @{
                'queued-at' = '2025-01-15T12:00:00.000Z'
            }
            message = $Message
            'is-destroy' = $false
            'auto-apply' = $false
            'plan-only' = $false
            'created-at' = '2025-01-15T12:00:00.000Z'
            permissions = @{
                'can-apply' = $true
                'can-cancel' = $true
                'can-discard' = $true
                'can-force-execute' = $false
                'can-force-cancel' = $false
            }
        }
        relationships = @{
            workspace = @{
                data = @{
                    id = $WorkspaceId
                    type = 'workspaces'
                }
            }
            plan = @{
                data = @{
                    id = "plan-$(New-Guid)"
                    type = 'plans'
                }
            }
            apply = @{
                data = $null
            }
        }
    }
}

function Get-MockPlan {
    param(
        [string]$Id = "plan-$(New-Guid)",
        [string]$Status = "finished",
        [int]$ResourceAdditions = 5,
        [int]$ResourceChanges = 2,
        [int]$ResourceDestructions = 0
    )

    return @{
        id = $Id
        type = 'plans'
        attributes = @{
            status = $Status
            'has-changes' = ($ResourceAdditions -gt 0 -or $ResourceChanges -gt 0 -or $ResourceDestructions -gt 0)
            'resource-additions' = $ResourceAdditions
            'resource-changes' = $ResourceChanges
            'resource-destructions' = $ResourceDestructions
            'log-read-url' = "https://example.com/logs/plan/$Id"
        }
    }
}

function Get-MockApply {
    param(
        [string]$Id = "apply-$(New-Guid)",
        [string]$Status = "finished",
        [int]$ResourceAdditions = 5,
        [int]$ResourceChanges = 2,
        [int]$ResourceDestructions = 0
    )

    return @{
        id = $Id
        type = 'applies'
        attributes = @{
            status = $Status
            'resource-additions' = $ResourceAdditions
            'resource-changes' = $ResourceChanges
            'resource-destructions' = $ResourceDestructions
            'log-read-url' = "https://example.com/logs/apply/$Id"
        }
    }
}

function Get-MockRunEvent {
    param(
        [string]$Id = "re-$(New-Guid)",
        [string]$Action = "created",
        [string]$Description = "Run created"
    )

    return @{
        id = $Id
        type = 'run-events'
        attributes = @{
            action = $Action
            description = $Description
            'created-at' = '2025-01-15T12:00:00.000Z'
        }
    }
}

Export-ModuleMember -Function @(
    'Get-MockRun',
    'Get-MockPlan',
    'Get-MockApply',
    'Get-MockRunEvent'
)
