# Mock Data for OAuth and Organization Tests
# Provides consistent test data for OAuth and organization operations

function Get-MockOAuthClient {
    param(
        [string]$Id = "oc-$(New-Guid)",
        [string]$ServiceProvider = "github",
        [string]$HttpUrl = "https://github.com"
    )

    return @{
        id = $Id
        type = 'oauth-clients'
        attributes = @{
            'service-provider' = $ServiceProvider
            'http-url' = $HttpUrl
            'api-url' = "https://api.$ServiceProvider.com"
            'created-at' = '2025-01-15T12:00:00.000Z'
        }
        relationships = @{
            organization = @{
                data = @{
                    id = 'test-org'
                    type = 'organizations'
                }
            }
            'oauth-tokens' = @{
                data = @()
            }
        }
    }
}

function Get-MockOAuthToken {
    param(
        [string]$Id = "ot-$(New-Guid)",
        [string]$HasSshKey = $false
    )

    return @{
        id = $Id
        type = 'oauth-tokens'
        attributes = @{
            'has-ssh-key' = $HasSshKey
            'created-at' = '2025-01-15T12:00:00.000Z'
        }
    }
}

function Get-MockOrganization {
    param(
        [string]$Name = "test-org",
        [string]$Email = "admin@test-org.com"
    )

    return @{
        id = $Name
        type = 'organizations'
        attributes = @{
            name = $Name
            email = $Email
            'collaborator-auth-policy' = 'password'
            'cost-estimation-enabled' = $true
            'created-at' = '2025-01-01T00:00:00.000Z'
            permissions = @{
                'can-update' = $true
                'can-destroy' = $true
                'can-create-workspace' = $true
            }
        }
    }
}

function Get-MockOrganizationMembership {
    param(
        [string]$Id = "ou-$(New-Guid)",
        [string]$Email = "user@example.com",
        [string]$Status = "active"
    )

    return @{
        id = $Id
        type = 'organization-memberships'
        attributes = @{
            email = $Email
            status = $Status
        }
        relationships = @{
            user = @{
                data = @{
                    id = "user-$(New-Guid)"
                    type = 'users'
                }
            }
            teams = @{
                data = @()
            }
        }
    }
}

Export-ModuleMember -Function @(
    'Get-MockOAuthClient',
    'Get-MockOAuthToken',
    'Get-MockOrganization',
    'Get-MockOrganizationMembership'
)
