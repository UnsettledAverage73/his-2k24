# Title: Audit Script for 'Load and unload device drivers' Policy
# Description: This script checks if the 'Load and unload device drivers' policy is set to 'Administrators' as per CIS recommendations.

Write-Host "Starting Audit: 'Load and unload device drivers' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeLoadDriverPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "*S-1-5-32-544" # SID for Administrators

# Check if the policy matches the expected value
if ($currentAccounts -eq $expectedAccounts) {
    Write-Host "PASS: 'Load and unload device drivers' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Load and unload device drivers' policy is set to: $currentAccounts. It should be 'Administrators'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

