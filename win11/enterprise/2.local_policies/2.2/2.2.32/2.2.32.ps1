# Title: Audit Script for 'Modify firmware environment values' Policy
# Description: This script checks if the 'Modify firmware environment values' policy is set to 'Administrators'.

Write-Host "Starting Audit: 'Modify firmware environment values' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeSystemEnvironmentPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "Administrators"

# Check if the policy matches the expected value
if ($currentAccounts -eq $expectedAccounts) {
    Write-Host "PASS: 'Modify firmware environment values' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Modify firmware environment values' policy is set to: $currentAccounts. It should be set to 'Administrators'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

