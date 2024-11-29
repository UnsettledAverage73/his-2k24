# Title: Audit Script for 'Manage auditing and security log' Policy
# Description: This script checks if the 'Manage auditing and security log' policy is set to 'Administrators'.

Write-Host "Starting Audit: 'Manage auditing and security log' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeSecurityPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "*S-1-5-32-544"  # S-1-5-32-544 corresponds to Administrators group

# Check if the policy matches the expected value
if ($currentAccounts -eq $expectedAccounts) {
    Write-Host "PASS: 'Manage auditing and security log' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Manage auditing and security log' policy is set to: $currentAccounts. It should be set to 'Administrators'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

