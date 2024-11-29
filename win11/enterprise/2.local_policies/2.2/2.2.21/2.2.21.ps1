# Title: Audit Script for 'Enable computer and user accounts to be trusted for delegation'
# Description: This script checks if the policy 'Enable computer and user accounts to be trusted for delegation' is set to 'No One' as per CIS recommendations.

Write-Host "Starting Audit: 'Enable computer and user accounts to be trusted for delegation' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeEnableDelegationPrivilege").ToString().Split('=')[1].Trim()

if ([string]::IsNullOrEmpty($currentAccounts)) {
    Write-Host "PASS: 'Enable computer and user accounts to be trusted for delegation' policy is correctly set to 'No One'." -ForegroundColor Green
} else {
    Write-Host "FAIL: The policy is incorrectly set. Current value: $currentAccounts" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

