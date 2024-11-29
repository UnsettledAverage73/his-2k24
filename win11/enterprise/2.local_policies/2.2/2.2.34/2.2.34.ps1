# Title: Audit Script for 'Profile single process' Policy
# Description: This script checks if the 'Profile single process' policy is set to 'Administrators'.

Write-Host "Starting Audit: 'Profile single process' policy" -ForegroundColor Green

# Check 'Profile single process' policy
$currentProfileProcess = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                           Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeProfileSingleProcessPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "Administrators"

# Check if the policy matches the expected value
if ($currentProfileProcess -eq $expectedAccounts) {
    Write-Host "PASS: 'Profile single process' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Profile single process' policy is set to: $currentProfileProcess. It should be set to 'Administrators'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

