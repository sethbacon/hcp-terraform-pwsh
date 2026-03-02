# Mock Data for Policy Tests
# Provides consistent test data for policy operations

function Get-MockPolicy {
    param(
        [string]$Id = "pol-$(New-Guid)",
        [string]$Name = "test-policy",
        [string]$EnforcementLevel = "advisory"
    )

    return @{
        id = $Id
        type = 'policies'
        attributes = @{
            name = $Name
            'enforcement-level' = $EnforcementLevel
            kind = 'sentinel'
            description = "Test policy for $Name"
            'created-at' = '2025-01-15T12:00:00.000Z'
            'updated-at' = '2025-01-15T12:00:00.000Z'
        }
    }
}

function Get-MockPolicySet {
    param(
        [string]$Id = "polset-$(New-Guid)",
        [string]$Name = "test-policy-set",
        [bool]$Global = $false
    )

    return @{
        id = $Id
        type = 'policy-sets'
        attributes = @{
            name = $Name
            description = "Test policy set for $Name"
            global = $Global
            'policies-count' = 2
            'workspaces-count' = if ($Global) { 0 } else { 3 }
            'created-at' = '2025-01-15T12:00:00.000Z'
        }
        relationships = @{
            policies = @{
                data = @()
            }
            workspaces = @{
                data = @()
            }
        }
    }
}

function Get-MockPolicyCheck {
    param(
        [string]$Id = "polchk-$(New-Guid)",
        [string]$Status = "passed",
        [string]$Scope = "organization"
    )

    return @{
        id = $Id
        type = 'policy-checks'
        attributes = @{
            status = $Status
            scope = $Scope
            result = @{
                passed = ($Status -eq 'passed')
                'total-failed' = if ($Status -eq 'passed') { 0 } else { 2 }
            }
        }
    }
}

function Get-MockPolicyEvaluation {
    param(
        [string]$Id = "poleval-$(New-Guid)",
        [string]$Status = "passed",
        [int]$PassedCount = 5,
        [int]$FailedCount = 0
    )

    return @{
        id = $Id
        type = 'policy-evaluations'
        attributes = @{
            status = $Status
            'result-count' = @{
                passed = $PassedCount
                failed = $FailedCount
                errored = 0
            }
            'created-at' = '2025-01-15T12:00:00.000Z'
        }
    }
}

function Get-MockPolicySetParameter {
    param(
        [string]$Id = "polsetparam-$(New-Guid)",
        [string]$Key = "test_param",
        [string]$Value = "test_value",
        [bool]$Sensitive = $false
    )

    return @{
        id = $Id
        type = 'policy-set-parameters'
        attributes = @{
            key = $Key
            value = if ($Sensitive) { $null } else { $Value }
            sensitive = $Sensitive
        }
    }
}

Export-ModuleMember -Function @(
    'Get-MockPolicy',
    'Get-MockPolicySet',
    'Get-MockPolicyCheck',
    'Get-MockPolicyEvaluation',
    'Get-MockPolicySetParameter'
)
