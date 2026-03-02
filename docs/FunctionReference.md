# TerraformCloud PowerShell Module - Function Reference

This document provides detailed information about all functions in the TerraformCloud PowerShell module.

Generated on: 2025-10-17 16:01:59

## Confirm-TfcRun

**Synopsis:** Applies a run

**Description:** Applies a run that is awaiting confirmation

**Parameters:**
- **RunId** (String): The run ID to apply - **Comment** (String): Optional comment for the apply - **WhatIf** (SwitchParameter):  - **Confirm** (SwitchParameter): 

**Examples:**
```powershell
Confirm-TfcRun -RunId "run-123" -Comment "Approved by admin"
```

---

## Deny-TfcRun

**Synopsis:** Discards a run

**Description:** Discards a run that is awaiting confirmation

**Parameters:**
- **RunId** (String): The run ID to discard - **Comment** (String): Optional comment for the discard action - **WhatIf** (SwitchParameter):  - **Confirm** (SwitchParameter): 

**Examples:**
```powershell
Deny-TfcRun -RunId "run-123" -Comment "Changes not approved"
```

---

## Find-TfcWorkspace

**Synopsis:** Finds a workspace by name across organizations

**Description:** Searches for a workspace by name, optionally within a specific organization

**Parameters:**
- **WorkspaceName** (String): The name of the workspace to find - **Organization** (String): Optional organization name to limit the search - **ListOrganizations** (SwitchParameter): Switch to list all accessible organizations instead of searching for a workspace

**Examples:**
```powershell
Find-TfcWorkspace -WorkspaceName "my-workspace"
``` ```powershell
Find-TfcWorkspace -WorkspaceName "my-workspace" -Organization "my-org"
``` ```powershell
Find-TfcWorkspace -ListOrganizations
```

---

## Get-TfcAccount

**Synopsis:** Gets the current user account information

**Description:** Retrieves information about the current user account from Terraform Cloud

**Parameters:**
None

**Examples:**
```powershell
Get-TfcAccount
```

---

## Get-TfcApply

**Synopsis:** Gets applies for a run

**Description:** Retrieves apply information for a specific run

**Parameters:**
- **RunId** (String): The run ID

**Examples:**
```powershell
Get-TfcApply -RunId "run-123"
```

---

## Get-TfcCurrentStateVersion

**Synopsis:** Gets the current state version for a workspace

**Description:** Retrieves the current state version from a Terraform Cloud workspace and optionally downloads the state file

**Parameters:**
- **WorkspaceId** (String): The workspace ID - **OutputPath** (String): Optional path to save the state file

**Examples:**
```powershell
Get-TfcCurrentStateVersion -WorkspaceId "ws-123"
``` ```powershell
Get-TfcCurrentStateVersion -WorkspaceId "ws-123" -OutputPath "./terraform.tfstate"
```

---

## Get-TfcCurrentUser

**Synopsis:** Gets user information from a token

**Description:** Retrieves user information for the specified user token

**Parameters:**
- **UserToken** (String): The user token to get information for (if not provided, uses current token)

**Examples:**
```powershell
Get-TfcCurrentUser
``` ```powershell
Get-TfcCurrentUser -UserToken "user-token-here"
```

---

## Get-TfcOAuthClient

**Synopsis:** Gets OAuth clients for an organization

**Description:** Retrieves VCS providers (OAuth clients) for a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name

**Examples:**
```powershell
Get-TfcOAuthClient -Organization "my-org"
```

---

## Get-TfcOrganization

**Synopsis:** Gets organizations accessible to the current user

**Description:** Retrieves a list of organizations that the current user has access to

**Parameters:**
- **Name** (String): Optional organization name to filter results - **AllPages** (SwitchParameter): Switch to retrieve all pages of results

**Examples:**
```powershell
Get-TfcOrganization
``` ```powershell
Get-TfcOrganization -Name "my-org"
```

---

## Get-TfcOrganizationEntitlements

**Synopsis:** Gets the entitlement set for an organization

**Description:** Retrieves the feature entitlements for a specific organization

**Parameters:**
- **Organization** (String): The organization name

**Examples:**
```powershell
Get-TfcOrganizationEntitlements -Organization "my-org"
```

---

## Get-TfcPlan

**Synopsis:** Gets plans for a run

**Description:** Retrieves plan information for a specific run

**Parameters:**
- **RunId** (String): The run ID

**Examples:**
```powershell
Get-TfcPlan -RunId "run-123"
```

---

## Get-TfcProject

**Synopsis:** Gets projects for an organization

**Description:** Retrieves projects from a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): Optional project name to get a specific project - **AllPages** (SwitchParameter): Switch to retrieve all pages of results - **PageSize** (Int32): Number of items per page (1-100, default 20) - **PageNumber** (Int32): Page number to retrieve (default 1)

**Examples:**
```powershell
Get-TfcProject -Organization "my-org"
``` ```powershell
Get-TfcProject -Organization "my-org" -Name "production"
```

---

## Get-TfcRegistryModule

**Synopsis:** Gets registry modules

**Description:** Retrieves registry modules from a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): Optional module name to get a specific module - **Provider** (String): Optional provider name (required with Name) - **AllPages** (SwitchParameter): Switch to retrieve all pages of results - **PageSize** (Int32): Number of items per page (1-100, default 20) - **PageNumber** (Int32): Page number to retrieve (default 1)

**Examples:**
```powershell
Get-TfcRegistryModule -Organization "my-org"
``` ```powershell
Get-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"
```

---

## Get-TfcRegistryProvider

**Synopsis:** Gets registry providers

**Description:** Retrieves registry providers from a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): Optional provider name to get a specific provider - **AllPages** (SwitchParameter): Switch to retrieve all pages of results - **PageSize** (Int32): Number of items per page (1-100, default 20) - **PageNumber** (Int32): Page number to retrieve (default 1)

**Examples:**
```powershell
Get-TfcRegistryProvider -Organization "my-org"
``` ```powershell
Get-TfcRegistryProvider -Organization "my-org" -Name "aws"
```

---

## Get-TfcRun

**Synopsis:** Gets runs for a workspace

**Description:** Retrieves runs from a Terraform Cloud workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID - **AllPages** (SwitchParameter): Switch to retrieve all pages of results - **PageSize** (Int32): Number of items per page (1-100, default 20) - **PageNumber** (Int32): Page number to retrieve (default 1)

**Examples:**
```powershell
Get-TfcRun -WorkspaceId "ws-123"
```

---

## Get-TfcStateVersion

**Synopsis:** Gets state versions for a workspace

**Description:** Retrieves state versions from a Terraform Cloud workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID - **StateVersionId** (String): Optional state version ID to get a specific version - **AllPages** (SwitchParameter): Switch to retrieve all pages of results - **PageSize** (Int32): Number of items per page (1-100, default 20) - **PageNumber** (Int32): Page number to retrieve (default 1)

**Examples:**
```powershell
Get-TfcStateVersion -WorkspaceId "ws-123"
``` ```powershell
Get-TfcStateVersion -StateVersionId "sv-abc123"
```

---

## Get-TfcStateVersionOutput

**Synopsis:** Gets state version outputs

**Description:** Retrieves outputs from a specific state version

**Parameters:**
- **StateVersionId** (String): The state version ID

**Examples:**
```powershell
Get-TfcStateVersionOutput -StateVersionId "sv-abc123"
```

---

## Get-TfcTeam

**Synopsis:** Gets teams for an organization

**Description:** Retrieves teams from a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name - **AllPages** (SwitchParameter): Switch to retrieve all pages of results

**Examples:**
```powershell
Get-TfcTeam -Organization "my-org"
```

---

## Get-TfcTeamAccess

**Synopsis:** Gets team access for a workspace

**Description:** Retrieves team access permissions for a specific workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID

**Examples:**
```powershell
Get-TfcTeamAccess -WorkspaceId "ws-123"
```

---

## Get-TfcVariableSet

**Synopsis:** Gets variable sets for an organization

**Description:** Retrieves variable sets from a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name - **AllPages** (SwitchParameter): Switch to retrieve all pages of results - **PageSize** (Int32): Number of items per page (1-100, default 20) - **PageNumber** (Int32): Page number to retrieve (default 1)

**Examples:**
```powershell
Get-TfcVariableSet -Organization "my-org"
``` ```powershell
Get-TfcVariableSet -Organization "my-org" -AllPages
```

---

## Get-TfcWorkspace

**Synopsis:** Gets workspaces from an organization

**Description:** Retrieves workspaces from a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): Optional workspace name to get a specific workspace - **AllPages** (SwitchParameter): Switch to retrieve all pages of results - **PageSize** (Int32): Number of items per page (1-100, default 20) - **PageNumber** (Int32): Page number to retrieve (default 1)

**Examples:**
```powershell
Get-TfcWorkspace -Organization "my-org"
``` ```powershell
Get-TfcWorkspace -Organization "my-org" -Name "my-workspace"
``` ```powershell
Get-TfcWorkspace -Organization "my-org" -AllPages
```

---

## Get-TfcWorkspaceVariable

**Synopsis:** Gets variables from a workspace

**Description:** Retrieves all variables from a specific workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID

**Examples:**
```powershell
Get-TfcWorkspaceVariable -WorkspaceId "ws-1234567890abcdef"
```

---

## Invoke-TfcApi

**Synopsis:** Invokes the Terraform Cloud API

**Description:** A generic function for making API calls to Terraform Cloud

**Parameters:**
- **Uri** (String): The API endpoint URI (relative to the base API URL) - **Method** (String): The HTTP method to use (GET, POST, PUT, PATCH, DELETE) - **Body** (String): The request body for POST/PUT/PATCH requests - **AllPages** (SwitchParameter): Switch to retrieve all pages for paginated responses

**Examples:**
```powershell
Invoke-TfcApi -Uri '/organizations' -Method GET
``` ```powershell
Invoke-TfcApi -Uri '/workspaces/ws-123/vars' -Method POST -Body $jsonBody
```

---

## Lock-TfcWorkspace

**Synopsis:** Locks a workspace

**Description:** Locks a workspace to prevent runs

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The workspace name - **Reason** (String): Optional reason for locking the workspace

**Examples:**
```powershell
Lock-TfcWorkspace -Organization "my-org" -Name "my-workspace" -Reason "Maintenance"
```

---

## New-TfcProject

**Synopsis:** Creates a new project

**Description:** Creates a new project in a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The project name - **Description** (String): Optional description for the project

**Examples:**
```powershell
New-TfcProject -Organization "my-org" -Name "production" -Description "Production workspaces"
```

---

## New-TfcRegistryModule

**Synopsis:** Creates a registry module from VCS

**Description:** Creates a new registry module in Terraform Cloud from a VCS repository

**Parameters:**
- **Organization** (String): The organization name - **VcsRepoIdentifier** (String): The VCS repository identifier (e.g., "org/repo") - **OAuthTokenId** (String): The OAuth token ID for VCS authentication

**Examples:**
```powershell
New-TfcRegistryModule -Organization "my-org" -VcsRepoIdentifier "myorg/terraform-aws-vpc" -OAuthTokenId "ot-abc123"
```

---

## New-TfcRegistryProvider

**Synopsis:** Creates a registry provider

**Description:** Creates a new registry provider in Terraform Cloud

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The provider name - **RegistryName** (String): The registry name (default: "private")

**Examples:**
```powershell
New-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
```

---

## New-TfcRun

**Synopsis:** Creates a new run

**Description:** Creates a new run in a Terraform Cloud workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID - **Message** (String): Optional message for the run - **IsDestroy** (SwitchParameter): Whether this is a destroy run - **AutoApply** (SwitchParameter): Whether to auto-apply this run - **ConfigurationVersionId** (String): Optional configuration version ID

**Examples:**
```powershell
New-TfcRun -WorkspaceId "ws-123" -Message "Deploy new infrastructure"
``` ```powershell
New-TfcRun -WorkspaceId "ws-123" -IsDestroy -Message "Destroy test environment"
```

---

## New-TfcStateVersion

**Synopsis:** Creates a new state version

**Description:** Creates a new state version in a Terraform Cloud workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID - **StateData** (String): The state JSON data as a string - **MD5** (String): MD5 hash of the state data - **Serial** (Int32): The serial number for the state - **Lineage** (String): The lineage for the state - **Force** (SwitchParameter): Force push even if serial/lineage don't match

**Examples:**
```powershell
$stateJson = Get-Content ./terraform.tfstate -Raw
New-TfcStateVersion -WorkspaceId "ws-123" -StateData $stateJson -MD5 "abc123..." -Serial 1
```

---

## New-TfcWorkspace

**Synopsis:** Creates a new workspace

**Description:** Creates a new workspace in a Terraform Cloud organization

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The workspace name - **TerraformVersion** (String): The Terraform version to use (default: "latest") - **WorkingDirectory** (String): The working directory for Terraform operations - **Description** (String): Optional description for the workspace - **AutoApply** (SwitchParameter): Whether to automatically apply successful plans - **VcsRepo** (Hashtable): VCS repository configuration (hashtable with repo-identifier, branch, etc.)

**Examples:**
```powershell
New-TfcWorkspace -Organization "my-org" -Name "new-workspace"
``` ```powershell
New-TfcWorkspace -Organization "my-org" -Name "new-workspace" -AutoApply -TerraformVersion "1.5.0"
```

---

## Remove-TfcProject

**Synopsis:** Removes a project

**Description:** Deletes a project from Terraform Cloud

**Parameters:**
- **ProjectId** (String): The project ID - **Force** (SwitchParameter): Skip confirmation prompt - **WhatIf** (SwitchParameter):  - **Confirm** (SwitchParameter): 

**Examples:**
```powershell
Remove-TfcProject -ProjectId "prj-123"
```

---

## Remove-TfcRegistryModule

**Synopsis:** Removes a registry module

**Description:** Deletes a registry module from Terraform Cloud

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The module name - **Provider** (String): The provider name - **Force** (SwitchParameter): Skip confirmation prompt - **WhatIf** (SwitchParameter):  - **Confirm** (SwitchParameter): 

**Examples:**
```powershell
Remove-TfcRegistryModule -Organization "my-org" -Name "vpc" -Provider "aws"
```

---

## Remove-TfcRegistryProvider

**Synopsis:** Removes a registry provider

**Description:** Deletes a registry provider from Terraform Cloud

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The provider name - **Force** (SwitchParameter): Skip confirmation prompt - **WhatIf** (SwitchParameter):  - **Confirm** (SwitchParameter): 

**Examples:**
```powershell
Remove-TfcRegistryProvider -Organization "my-org" -Name "custom-provider"
```

---

## Remove-TfcWorkspace

**Synopsis:** Removes a workspace

**Description:** Deletes a workspace from Terraform Cloud

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The workspace name - **Force** (SwitchParameter): Skip confirmation prompt - **WhatIf** (SwitchParameter):  - **Confirm** (SwitchParameter): 

**Examples:**
```powershell
Remove-TfcWorkspace -Organization "my-org" -Name "old-workspace"
```

---

## Remove-TfcWorkspaceVariable

**Synopsis:** Removes a variable from a workspace

**Description:** Deletes a variable from a Terraform Cloud workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID - **Key** (String): The variable name/key to remove - **WhatIf** (SwitchParameter):  - **Confirm** (SwitchParameter): 

**Examples:**
```powershell
Remove-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "old_variable"
```

---

## Set-TfcWorkspaceVariable

**Synopsis:** Sets a variable in a workspace

**Description:** Creates or updates a variable in a Terraform Cloud workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID - **Key** (String): The variable name/key - **Value** (String): The variable value - **Category** (String): The variable category (terraform or env) - **HCL** (SwitchParameter): Whether the variable should be parsed as HCL - **Sensitive** (SwitchParameter): Whether the variable is sensitive - **Description** (String): Optional description for the variable

**Examples:**
```powershell
Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-east-1" -Category "terraform"
``` ```powershell
Set-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "API_KEY" -Value "secret" -Category "env" -Sensitive
```

---

## Stop-TfcRun

**Synopsis:** Cancels a run

**Description:** Cancels a run that is in progress

**Parameters:**
- **RunId** (String): The run ID to cancel - **Comment** (String): Optional comment for the cancel action - **WhatIf** (SwitchParameter):  - **Confirm** (SwitchParameter): 

**Examples:**
```powershell
Stop-TfcRun -RunId "run-123" -Comment "Cancelling due to emergency"
```

---

## Test-TfcWorkspaceId

**Synopsis:** Tests if a workspace ID is valid

**Description:** Validates the format of a Terraform Cloud workspace ID

**Parameters:**
- **WorkspaceId** (String): The workspace ID to validate

**Examples:**
```powershell
Test-TfcWorkspaceId -WorkspaceId "ws-1234567890abcdef"
```

---

## Unlock-TfcWorkspace

**Synopsis:** Unlocks a workspace

**Description:** Unlocks a workspace to allow runs

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The workspace name

**Examples:**
```powershell
Unlock-TfcWorkspace -Organization "my-org" -Name "my-workspace"
```

---

## Update-TfcProject

**Synopsis:** Updates a project

**Description:** Updates an existing project in Terraform Cloud

**Parameters:**
- **ProjectId** (String): The project ID - **Name** (String): New name for the project - **Description** (String): New description for the project

**Examples:**
```powershell
Update-TfcProject -ProjectId "prj-123" -Name "new-name" -Description "Updated description"
```

---

## Update-TfcWorkspace

**Synopsis:** Updates a workspace

**Description:** Updates an existing workspace in Terraform Cloud

**Parameters:**
- **Organization** (String): The organization name - **Name** (String): The workspace name - **NewName** (String): New name for the workspace (optional) - **TerraformVersion** (String): The Terraform version to use - **WorkingDirectory** (String): The working directory for Terraform operations - **Description** (String): Description for the workspace - **AutoApply** (Boolean): Whether to automatically apply successful plans

**Examples:**
```powershell
Update-TfcWorkspace -Organization "my-org" -Name "my-workspace" -TerraformVersion "1.5.0"
```

---

## Update-TfcWorkspaceVariable

**Synopsis:** Updates a variable in a workspace

**Description:** Updates an existing variable in a Terraform Cloud workspace

**Parameters:**
- **WorkspaceId** (String): The workspace ID - **Key** (String): The variable name/key to update - **Value** (String): The new variable value - **Category** (String): The variable category (terraform or env) - **HCL** (SwitchParameter): Whether the variable should be parsed as HCL - **Sensitive** (SwitchParameter): Whether the variable is sensitive - **Description** (String): Optional description for the variable

**Examples:**
```powershell
Update-TfcWorkspaceVariable -WorkspaceId "ws-123" -Key "region" -Value "us-west-2" -Category "terraform"
```

---

