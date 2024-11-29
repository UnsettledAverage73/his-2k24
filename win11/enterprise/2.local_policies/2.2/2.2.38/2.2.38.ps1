# Title: Audit Script for 'Shut down the system' Policy
# Description: This script checks if the 'Shut down the system' policy is set to 'Administrators, Users'.

Write-Host "Starting Audit: 'Shut down the system' policy" -ForegroundColor Green

# Export current security policy to a temporary file
secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null

# Read the current setting for 'Shut down the system' policy
$currentShutdownPolicy = (Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeShutdownPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "Administrators, Users"

# Compare the current setting with the expected value
if ($currentShutdownPolicy -eq $expectedAccounts) {
    Write-Host "PASS: 'Shut down the system' policy is correctly set to 'Administrators, Users'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Shut down the system' policy is set to: $currentShutdownPolicy. It should be set to 'Administrators, Users'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

