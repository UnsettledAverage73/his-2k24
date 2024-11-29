# Title: Audit Script for 'Lock pages in memory' Policy
# Description: This script checks if the 'Lock pages in memory' policy is set to 'No One' as per CIS recommendations.

Write-Host "Starting Audit: 'Lock pages in memory' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeLockMemoryPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = ""

# Check if the policy matches the expected value
if ($currentAccounts -eq $expectedAccounts) {
    Write-Host "PASS: 'Lock pages in memory' policy is correctly set to 'No One'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Lock pages in memory' policy is set to: $currentAccounts. It should be 'No One'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

