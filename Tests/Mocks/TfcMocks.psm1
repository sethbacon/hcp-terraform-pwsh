# TerraformCloud Test Mocks
# Central module for all mock data used in tests

# Import all mock modules
$mocksPath = $PSScriptRoot

Import-Module (Join-Path $mocksPath 'WorkspaceMocks.psm1') -Force
Import-Module (Join-Path $mocksPath 'RunMocks.psm1') -Force
Import-Module (Join-Path $mocksPath 'StateMocks.psm1') -Force
Import-Module (Join-Path $mocksPath 'PolicyMocks.psm1') -Force
Import-Module (Join-Path $mocksPath 'OrganizationMocks.psm1') -Force

# Re-export all mock functions
Export-ModuleMember -Function @(
    # Workspace Mocks
    'Get-MockWorkspace',
    'Get-MockWorkspaceList',
    'Get-MockWorkspaceVariable',

    # Run Mocks
    'Get-MockRun',
    'Get-MockPlan',
    'Get-MockApply',
    'Get-MockRunEvent',

    # State Mocks
    'Get-MockStateVersion',
    'Get-MockStateVersionOutput',
    'Get-MockStateFile',

    # Policy Mocks
    'Get-MockPolicy',
    'Get-MockPolicySet',
    'Get-MockPolicyCheck',
    'Get-MockPolicyEvaluation',
    'Get-MockPolicySetParameter',

    # Organization Mocks
    'Get-MockOAuthClient',
    'Get-MockOAuthToken',
    'Get-MockOrganization',
    'Get-MockOrganizationMembership'
)
