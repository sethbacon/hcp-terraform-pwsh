# Test Framework Modernization & Parallelization Plan

## Executive Summary

**Current State:**
- ✅ 275 unit test files (621 test cases)
- ✅ 100% pass rate
- ⚠️ Sequential execution (~30-37 seconds)
- ❌ Missing integration tests from original suite
- ❌ Missing mock mode support
- ❌ Missing safety features

**Original Monolithic Test:**
- 420 test assertions across 179 numbered tests
- Comprehensive mock mode support
- Integration test scenarios
- Safety checks for production
- Test organization selection

**Goal:** Port all missing features + implement parallelization for <15s execution time

---

## Phase 1: Infrastructure Enhancement (Priority: HIGH)

### 1.1 Mock Mode Infrastructure
**Status:** ❌ NOT STARTED
**Effort:** 4-6 hours
**Files to Create/Modify:**
- `Tests/Helpers/MockMode.psm1` - Mock mode orchestration
- `Tests/Mocks/Initialize-MockData.ps1` - Comprehensive mock data initialization
- `Tests/Helpers/TestHelpers.psm1` - Add mock mode support

**Key Features to Port:**
```powershell
# From original: Initialize-MockData function
# Creates ~50 mock resource types:
- Organizations, Workspaces, Runs, Plans, Applies
- Variables, Variable Sets
- Teams, Team Access, Team Tokens
- Policies, Policy Sets, Policy Evaluations
- Agent Pools, Agents, Agent Tokens
- SSH Keys, Notification Configurations
- Run Tasks, Run Triggers
- State Versions, Configuration Versions
- OAuth Clients, Registry Modules/Providers
- Projects, Cost Estimates
```

**Implementation:**
- Create structured mock data with realistic IDs
- Support for mock function routing (Invoke-MockTfcFunction pattern)
- Parameter validation in mock mode
- Consistent mock response structure

### 1.2 Safety & Control Features
**Status:** ❌ NOT STARTED
**Effort:** 2-3 hours
**Files to Create:**
- `Tests/Helpers/Safety.psm1` - Production safety checks
- `Tests/Configuration/TestConfig.psd1` - Test configuration

**Key Features to Port:**
```powershell
# Test-ProductionSafety function
- Verify test organization name contains "test" or "demo"
- Prevent accidental production testing
- Require explicit confirmation for destructive tests

# Test execution parameters
-MockMode              # Run without API calls
-RunDestructiveTests   # Enable create/delete operations
-UseTestOrganization   # Specify test org name
-SkipProductionCheck   # Override safety (requires confirmation)
```

### 1.3 Test Result Tracking & Reporting
**Status:** ❌ NOT STARTED
**Effort:** 2-3 hours
**Files to Create:**
- `Tests/Helpers/TestReporting.psm1` - Enhanced test result tracking

**Key Features to Port:**
```powershell
# Add-TestResult function with status types:
- PASS (green)
- MOCK (cyan)
- WARN (yellow)
- FAIL (red)
- SKIP (gray)

# Summary reporting:
- Total tests run
- Pass/Fail/Mock/Skip counts
- Execution time per phase
- Failed test details with cleanup requirements
```

---

## Phase 2: Integration Test Suite (Priority: HIGH)

### 2.1 Core Workflow Integration Tests
**Status:** ⏳ PARTIALLY STARTED (1/28+ scenarios)
**Effort:** 8-12 hours
**Files to Create:**

#### Workspace Lifecycle (DONE ✅)
- `Tests/Integration/WorkspaceLifecycle.Tests.ps1`

#### Variable Management (TODO ❌)
- `Tests/Integration/VariableManagement.Tests.ps1`
  - Create variable set
  - Add variables (Terraform + Environment)
  - Assign to workspace
  - Update variables
  - Remove variable set
  - Cleanup verification

#### Configuration Version Workflow (TODO ❌)
- `Tests/Integration/ConfigurationVersionWorkflow.Tests.ps1`
  - Create configuration version
  - Upload configuration
  - Verify ingress status
  - Trigger run from configuration
  - Verify plan/apply

#### Team & Access Management (TODO ❌)
- `Tests/Integration/TeamAccessManagement.Tests.ps1`
  - Create team
  - Add team members
  - Grant workspace access (read/plan/write/admin)
  - Update access levels
  - Remove access
  - Delete team

#### Policy Compliance Workflow (TODO ❌)
- `Tests/Integration/PolicyCompliance.Tests.ps1`
  - Create policy
  - Upload policy content
  - Create policy set
  - Attach policies to set
  - Assign to workspace
  - Trigger run with policy checks
  - Verify policy evaluation
  - Handle policy overrides

#### State Management (TODO ❌)
- `Tests/Integration/StateManagement.Tests.ps1`
  - Create state version
  - Lock state
  - Update state
  - Unlock state
  - Roll back state version
  - Verify state integrity

### 2.2 Extended Integration Tests
**Effort:** 6-8 hours

#### Run Task Integration (TODO ❌)
- `Tests/Integration/RunTaskWorkflow.Tests.ps1`
  - Create run task
  - Attach to workspace (pre-plan/post-plan)
  - Set enforcement level (advisory/mandatory)
  - Trigger run with task
  - Verify task execution
  - Update enforcement
  - Remove task

#### Run Trigger Integration (TODO ❌)
- `Tests/Integration/RunTriggerWorkflow.Tests.ps1`
  - Create source workspace
  - Create target workspace
  - Create run trigger
  - Trigger source workspace run
  - Verify cascading run in target
  - Remove trigger

#### Agent Pool Integration (TODO ❌)
- `Tests/Integration/AgentPoolWorkflow.Tests.ps1`
  - Create agent pool
  - Generate agent token
  - Configure workspace for agent execution
  - Trigger agent-based run
  - Verify agent assignment
  - Cleanup pool and tokens

#### Notification Configuration (TODO ❌)
- `Tests/Integration/NotificationWorkflow.Tests.ps1`
  - Create notification (Slack/Email/Generic)
  - Configure triggers (all events/specific states)
  - Test notification
  - Verify delivery
  - Update configuration
  - Remove notification

#### SSH Key Workflow (TODO ❌)
- `Tests/Integration/SshKeyWorkflow.Tests.ps1`
  - Create SSH key
  - Assign to workspace
  - Verify VCS integration with key
  - Update key
  - Remove key

#### OAuth Client Integration (TODO ❌)
- `Tests/Integration/OAuthClientWorkflow.Tests.ps1`
  - Create OAuth client
  - Configure service provider
  - Test authorization
  - Update settings
  - Remove client

---

## Phase 3: Test Parallelization (Priority: HIGH)

### 3.1 Pester Parallel Configuration
**Status:** ❌ NOT STARTED
**Effort:** 3-4 hours
**Files to Create:**
- `Tests/Run-ParallelTests.ps1` - Parallel test runner
- `Tests/Configuration/PesterConfig.psd1` - Pester configuration

**Implementation Strategy:**

```powershell
# Pester 5.x parallel execution
$PesterConfig = New-PesterConfiguration

# Parallel execution settings
$PesterConfig.Run.Path = "$PSScriptRoot/Unit", "$PSScriptRoot/Integration"
$PesterConfig.Run.Parallel = $true
$PesterConfig.Run.PassThru = $true

# Performance optimization
$PesterConfig.Run.ParallelExecutionThrottle = [System.Environment]::ProcessorCount

# Output configuration
$PesterConfig.Output.Verbosity = 'Detailed'
$PesterConfig.Output.CIFormat = 'Auto'

# Code coverage (optional)
$PesterConfig.CodeCoverage.Enabled = $true
$PesterConfig.CodeCoverage.Path = "$PSScriptRoot/../TerraformCloud.psd1"

# Execute
Invoke-Pester -Configuration $PesterConfig
```

**Challenges & Solutions:**

1. **Test Isolation**
   - Problem: Tests may conflict when creating/deleting resources
   - Solution: Use unique resource names with test run ID/timestamp
   - Pattern: `test-resource-${TestRunId}-${ResourceType}`

2. **Mock State Management**
   - Problem: Shared mock data may cause race conditions
   - Solution: Thread-safe mock data access or per-thread mock instances
   - Implementation: Use `[System.Collections.Concurrent.ConcurrentDictionary]`

3. **API Rate Limiting**
   - Problem: Parallel tests may hit rate limits
   - Solution: Implement exponential backoff in Invoke-TfcApi
   - Already implemented in module ✅

4. **Output Clarity**
   - Problem: Parallel test output can be confusing
   - Solution: Use Pester's built-in parallel output formatting
   - Configure: `$PesterConfig.Output.Verbosity = 'Detailed'`

### 3.2 Test Categorization
**Status:** ❌ NOT STARTED
**Effort:** 2-3 hours

**Tag-Based Execution:**
```powershell
# Unit tests (fast, highly parallel)
Describe "Get-TfcWorkspace" -Tag "Unit", "Fast", "Read" {
    # ...
}

# Integration tests (slower, limited parallelism)
Describe "Workspace Lifecycle" -Tag "Integration", "Slow", "Destructive" {
    # ...
}

# Run specific categories
Invoke-Pester -Tag "Unit", "Fast"  # Fast unit tests only
Invoke-Pester -ExcludeTag "Destructive"  # Skip destructive tests
```

**Test Categories:**
- `Unit` - Single function tests
- `Integration` - Multi-function workflows
- `Fast` - <1s execution
- `Slow` - >1s execution
- `Read` - Read-only operations
- `Write` - Create/update operations
- `Destructive` - Delete operations
- `RequiresOrg` - Needs test organization
- `RequiresMock` - Can run in mock mode

### 3.3 Performance Targets
**Current:** ~30-37s sequential
**Target:** <15s with parallelization

**Expected Performance Gains:**
- Unit tests (621 tests): 30s → 8s (4x speedup with 8 cores)
- Integration tests (estimated 100 tests): 60s → 20s (3x speedup)
- **Total estimated time: ~28s → 10s (65% improvement)**

**Optimization Strategies:**
1. Run unit tests with maximum parallelism (all cores)
2. Run integration tests with limited parallelism (2-4 concurrent)
3. Skip slow tests in CI (optional tag-based filtering)
4. Use mock mode for unit tests (zero API latency)

---

## Phase 4: Test Coverage Parity (Priority: MEDIUM)

### 4.1 Missing Test Scenarios from Original
**Status:** ❌ NOT STARTED
**Effort:** 4-6 hours

**Functions with Enhanced Testing in Original:**

1. **Workspace Tests (Enhanced)**
   - Lock/unlock workflow
   - Force unlock with confirmation
   - Tag management (add/remove/update)
   - Remote state consumers
   - Current state version validation

2. **Run Tests (Enhanced)**
   - Run lifecycle (create → queue → plan → apply → complete)
   - Run cancellation and force-cancel
   - Run discarding
   - Run comments and status updates
   - Plan/apply log streaming
   - Cost estimate validation

3. **Variable Tests (Enhanced)**
   - Variable set global vs workspace-specific
   - Variable set priority/precedence
   - Sensitive variable handling
   - HCL variable parsing
   - Variable conflicts and resolution

4. **Team Tests (Enhanced)**
   - Team membership management
   - Organization access levels
   - Workspace access inheritance
   - Team token lifecycle

5. **Policy Tests (Enhanced)**
   - Policy evaluation status tracking
   - Hard vs soft mandatory enforcement
   - Policy override workflows
   - Policy set versioning
   - VCS-backed policy sets

### 4.2 Error Handling & Edge Cases
**Status:** ⏳ PARTIAL (basic error handling exists)
**Effort:** 3-4 hours

**Enhanced Error Testing:**
```powershell
# From original test patterns
It "Should handle non-existent workspace gracefully" {
    { Get-TfcWorkspace -Organization "test-org" -Name "nonexistent" -ErrorAction Stop } |
        Should -Throw "*Workspace not found*"
}

It "Should validate required parameters" {
    { New-TfcWorkspace -Organization "test-org" } |
        Should -Throw "*Name parameter is required*"
}

It "Should handle API rate limiting" {
    # Mock rate limit response
    Mock Invoke-RestMethod { throw [System.Net.WebException]::new("429 Too Many Requests") }
    { Get-TfcWorkspace -Organization "test-org" -Name "test" -ErrorAction Stop } |
        Should -Throw "*Rate limit*"
}
```

---

## Phase 5: CI/CD Integration (Priority: LOW)

### 5.1 Azure DevOps Pipeline Integration
**Status:** ❌ NOT STARTED
**Effort:** 2-3 hours
**Files to Create:**
- `.azure-pipelines/test-pipeline.yml`

**Pipeline Configuration:**
```yaml
trigger:
  branches:
    include:
      - main
      - develop
  paths:
    include:
      - TerraformCloud.psd1
      - Tests/**

stages:
  - stage: Test
    jobs:
      - job: UnitTests
        pool:
          vmImage: 'windows-latest'
        steps:
          - pwsh: |
              Install-Module Pester -MinimumVersion 5.0 -Force -SkipPublisherCheck
              $config = New-PesterConfiguration
              $config.Run.Path = './Tests/Unit'
              $config.Run.Parallel = $true
              $config.Output.Verbosity = 'Detailed'
              $config.TestResult.Enabled = $true
              $config.TestResult.OutputFormat = 'NUnitXml'
              $config.TestResult.OutputPath = './TestResults.xml'
              Invoke-Pester -Configuration $config
            displayName: 'Run Unit Tests'

          - task: PublishTestResults@2
            inputs:
              testResultsFormat: 'NUnit'
              testResultsFiles: '**/TestResults.xml'
            condition: always()

      - job: IntegrationTests
        dependsOn: UnitTests
        condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
        pool:
          vmImage: 'windows-latest'
        steps:
          - pwsh: |
              # Run integration tests (requires TFC token)
              $env:TFC_TOKEN = "$(TFC_API_TOKEN)"
              $config = New-PesterConfiguration
              $config.Run.Path = './Tests/Integration'
              $config.Run.Parallel = $false  # Sequential for integration
              Invoke-Pester -Configuration $config
            displayName: 'Run Integration Tests'
```

### 5.2 Test Reporting & Metrics
**Files to Create:**
- `Tests/Helpers/CodeCoverage.psm1` - Coverage analysis
- `Tests/Reports/` - Test result storage

**Metrics to Track:**
- Test execution time trends
- Pass/fail rates over time
- Code coverage percentage
- Flaky test detection
- Performance regression detection

---

## Phase 6: Documentation & Maintenance (Priority: LOW)

### 6.1 Test Documentation
**Files to Create:**
- `Tests/README.md` - Test framework guide
- `Tests/CONTRIBUTING.md` - Test writing guidelines
- `Tests/Examples/` - Example test patterns

**Documentation Topics:**
- How to run tests (unit/integration/parallel/sequential)
- How to write new tests (patterns and best practices)
- Mock mode usage
- Safety features and controls
- Troubleshooting test failures
- CI/CD integration

### 6.2 Test Maintenance Scripts
**Files to Create:**
- `Tests/Tools/Update-TestTemplates.ps1` - Auto-update test structure
- `Tests/Tools/Validate-TestCoverage.ps1` - Ensure all functions tested
- `Tests/Tools/Find-FlakyTests.ps1` - Identify unreliable tests

---

## Implementation Timeline

### Week 1: Foundation (Priority Items)
- ✅ Day 1-2: Mock mode infrastructure (Phase 1.1)
- ✅ Day 3: Safety features (Phase 1.2)
- ✅ Day 4: Test result tracking (Phase 1.3)
- ✅ Day 5: Parallelization setup (Phase 3.1-3.2)

### Week 2: Integration Tests
- ✅ Day 1-2: Core workflows (Phase 2.1) - 5 scenarios
- ✅ Day 3-4: Extended workflows (Phase 2.2) - 6 scenarios
- ✅ Day 5: Test coverage parity (Phase 4.1)

### Week 3: Polish & Documentation
- ✅ Day 1: Error handling enhancement (Phase 4.2)
- ✅ Day 2: CI/CD integration (Phase 5.1)
- ✅ Day 3-5: Documentation (Phase 6)

---

## Success Criteria

### Must Have (MVP)
- [ ] All 179 test scenarios from original ported to new framework
- [ ] Mock mode fully functional for all tests
- [ ] Parallel execution implemented with <15s runtime
- [ ] Safety features prevent production testing
- [ ] 100% test pass rate maintained

### Should Have
- [ ] Integration test suite covering all major workflows
- [ ] CI/CD pipeline integration
- [ ] Enhanced error handling tests
- [ ] Test result tracking and reporting

### Nice to Have
- [ ] Code coverage >80%
- [ ] Flaky test detection
- [ ] Performance regression testing
- [ ] Comprehensive documentation

---

## Risk Assessment

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| API rate limiting during parallel tests | HIGH | MEDIUM | Implement rate limit handling, use mock mode |
| Test isolation failures | HIGH | MEDIUM | Use unique resource names, proper cleanup |
| Parallel test output confusion | LOW | HIGH | Use Pester's built-in formatting |
| Integration test brittleness | MEDIUM | MEDIUM | Add retries, improve error handling |
| Mock data staleness | MEDIUM | LOW | Regular updates from API schema |
| Performance regression | LOW | LOW | Continuous monitoring, benchmarking |

---

## Next Steps

**IMMEDIATE (Today):**
1. Implement mock mode infrastructure (4-6 hours)
2. Add safety features (2-3 hours)
3. Set up parallel execution (3-4 hours)

**THIS WEEK:**
4. Port 5 core integration test scenarios (8-12 hours)
5. Implement test result tracking (2-3 hours)

**NEXT WEEK:**
6. Complete remaining integration tests (6-8 hours)
7. Enhance error handling tests (3-4 hours)
8. CI/CD integration (2-3 hours)

**ONGOING:**
- Monitor test performance
- Update documentation
- Maintain mock data accuracy
- Review and improve test coverage

---

## Questions for Review

1. **Priority Confirmation**: Is parallelization or integration test coverage higher priority?
2. **Mock Mode Usage**: Should unit tests ALWAYS use mock mode (no API calls)?
3. **Destructive Tests**: Should destructive tests be opt-in only (requires flag)?
4. **Test Organization**: Do we have a dedicated test organization in TFC/TFE?
5. **CI/CD**: Which CI/CD system(s) need integration (Azure DevOps, GitHub Actions, Jenkins)?
6. **Coverage Target**: Is 100% function coverage required, or can we focus on critical paths?

