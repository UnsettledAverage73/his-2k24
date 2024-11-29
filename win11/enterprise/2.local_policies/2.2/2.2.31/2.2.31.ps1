# Title: Audit Script for 'Modify an object label' Policy
# Description: This script checks if the 'Modify an object label' policy is set to 'No One'.

Write-Host "Starting Audit: 'Modify an object label' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeRelabelPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = ""

# Check if the policy matches the expected value
if ($currentAccounts -eq $expectedAccounts) {
    Write-Host "PASS: 'Modify an object label' policy is correctly set to 'No One'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Modify an object label' policy is set to: $currentAccounts. It should be set to 'No One'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

