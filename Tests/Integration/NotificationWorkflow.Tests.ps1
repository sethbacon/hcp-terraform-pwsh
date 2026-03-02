# Integration Test: Notification Workflow
# Tests notification configuration creation and testing

BeforeAll {
    $helpersPath = Join-Path $PSScriptRoot '..' 'Helpers' 'TestHelpers.psm1'
    Import-Module $helpersPath -Force

    $modulePath = Join-Path $PSScriptRoot '..' '..' 'Output' 'TerraformCloud' 'TerraformCloud.psd1'
    Import-Module $modulePath -Force

    $env:TFE_TOKEN = "test-token-12345"
}

AfterAll {
    Remove-Module TerraformCloud -Force -ErrorAction SilentlyContinue
    Remove-Module TestHelpers -Force -ErrorAction SilentlyContinue
}

Describe 'Notification Workflow Integration Test' -Tag 'Integration', 'Notifications' {
    BeforeAll {
        $testWorkspaceId = 'ws-test123'
    }

    Context 'Slack Notification Lifecycle' {
        It 'Step 1: Create Slack notification' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'nc-slack-123'
                        type = 'notification-configurations'
                        attributes = @{
                            name = $Body.data.attributes.name
                            'destination-type' = 'slack'
                            enabled = $true
                            url = $Body.data.attributes.url
                            triggers = $Body.data.attributes.triggers
                        }
                    }
                }
            }

            $notification = New-TfcNotificationConfiguration -WorkspaceId $testWorkspaceId `
                -Name "Slack Notifications" `
                -DestinationType 'slack' `
                -Url 'https://hooks.slack.com/services/TEST/WEBHOOK' `
                -Triggers @('run:needs_attention')

            $notification.data.attributes.'destination-type' | Should -Be 'slack'
            $notification.data.attributes.enabled | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 2: Test notification delivery' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        attributes = @{
                            'delivery-responses' = @(
                                @{
                                    successful = $true
                                    message = 'Test notification delivered'
                                }
                            )
                        }
                    }
                }
            }

            $test = Test-TfcNotificationConfiguration -NotificationConfigurationId 'nc-slack-123'

            $test.data.attributes.'delivery-responses'[0].successful | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 3: Update notification triggers' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'nc-slack-123'
                        attributes = @{
                            triggers = @('run:completed', 'run:errored')
                        }
                    }
                }
            }

            $updated = Update-TfcNotificationConfiguration -NotificationConfigurationId 'nc-slack-123' `
                -Triggers @('run:completed', 'run:errored')

            $updated.data.attributes.triggers.Count | Should -Be 2
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 4: Disable notification' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'nc-slack-123'
                        attributes = @{
                            enabled = $false
                        }
                    }
                }
            }

            $updated = Update-TfcNotificationConfiguration -NotificationConfigurationId 'nc-slack-123' `
                -Enabled:$false

            $updated.data.attributes.enabled | Should -BeFalse
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Step 5: Delete notification' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return $true
            }

            $result = Remove-TfcNotificationConfiguration -NotificationConfigurationId 'nc-slack-123' -Confirm:$false

            $result | Should -BeTrue
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Email Notification' {
        It 'Should create email notification' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'nc-email-123'
                        attributes = @{
                            name = 'Email Notifications'
                            'destination-type' = 'email'
                            enabled = $true
                            'email-addresses' = @('admin@example.com')
                            triggers = @('run:needs_attention')
                        }
                    }
                }
            }

            $notification = New-TfcNotificationConfiguration -WorkspaceId $testWorkspaceId `
                -Name "Email Notifications" `
                -DestinationType 'email' `
                -EmailAddresses @('admin@example.com') `
                -Triggers @('run:needs_attention')

            $notification.data.attributes.'destination-type' | Should -Be 'email'
            $notification.data.attributes.'email-addresses'[0] | Should -Be 'admin@example.com'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Generic Webhook Notification' {
        It 'Should create generic webhook notification' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'nc-webhook-123'
                        attributes = @{
                            name = 'Webhook Notifications'
                            'destination-type' = 'generic'
                            enabled = $true
                            url = 'https://example.com/webhook'
                            triggers = @('run:completed')
                        }
                    }
                }
            }

            $notification = New-TfcNotificationConfiguration -WorkspaceId $testWorkspaceId `
                -Name "Webhook Notifications" `
                -DestinationType 'generic' `
                -Url 'https://example.com/webhook' `
                -Triggers @('run:completed')

            $notification.data.attributes.'destination-type' | Should -Be 'generic'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'Notification Triggers' {
        It 'Should support all run event triggers' {
            $triggers = @(
                'run:created'
                'run:planning'
                'run:needs_attention'
                'run:applying'
                'run:completed'
                'run:errored'
            )

            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'nc-all-triggers'
                        attributes = @{
                            triggers = $triggers
                        }
                    }
                }
            }

            $notification = New-TfcNotificationConfiguration -WorkspaceId $testWorkspaceId `
                -Name "All Events" `
                -DestinationType 'slack' `
                -Url 'https://hooks.slack.com/services/TEST' `
                -Triggers $triggers

            $notification.data.attributes.triggers.Count | Should -Be 6
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }

        It 'Should support assessment triggers' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @{
                        id = 'nc-assessment'
                        attributes = @{
                            triggers = @('assessment:check_failure', 'assessment:drifted', 'assessment:failed')
                        }
                    }
                }
            }

            $notification = New-TfcNotificationConfiguration -WorkspaceId $testWorkspaceId `
                -Name "Assessment Events" `
                -DestinationType 'slack' `
                -Url 'https://hooks.slack.com/services/TEST' `
                -Triggers @('assessment:check_failure', 'assessment:drifted', 'assessment:failed')

            $notification.data.attributes.triggers | Should -Contain 'assessment:drifted'
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }

    Context 'List Notifications' {
        It 'Should list all workspace notifications' {
            Mock Invoke-TfcApi -ModuleName TerraformCloud {
                return @{
                    data = @(
                        @{
                            id = 'nc-slack-123'
                            attributes = @{
                                name = 'Slack Notifications'
                                'destination-type' = 'slack'
                            }
                        },
                        @{
                            id = 'nc-email-123'
                            attributes = @{
                                name = 'Email Notifications'
                                'destination-type' = 'email'
                            }
                        }
                    )
                }
            }

            $notifications = Get-TfcNotificationConfiguration -WorkspaceId $testWorkspaceId

            $notifications.data.Count | Should -Be 2
            Should -Invoke Invoke-TfcApi -ModuleName TerraformCloud -Times 1
        }
    }
}


