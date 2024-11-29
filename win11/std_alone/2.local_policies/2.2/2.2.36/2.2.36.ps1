# Title: Audit Script for 'Replace a process level token' Policy
# Description: This script checks if the 'Replace a process level token' policy is set to 'LOCAL SERVICE, NETWORK SERVICE'.

Write-Host "Starting Audit: 'Replace a process level token' policy" -ForegroundColor Green

# Check 'Replace a process level token' policy
$currentProcessLevelToken = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                               Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeReplaceProcessTokenPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "LOCAL SERVICE, NETWORK SERVICE"

# Check if the policy matches the expected value
if ($currentProcessLevelToken -eq $expectedAccounts) {
    Write-Host "PASS: 'Replace a process level token' policy is correctly set to 'LOCAL SERVICE, NETWORK SERVICE'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Replace a process level token' policy is set to: $currentProcessLevelToken. It should be set to 'LOCAL SERVICE, NETWORK SERVICE'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

