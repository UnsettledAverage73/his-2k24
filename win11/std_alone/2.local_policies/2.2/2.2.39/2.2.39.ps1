# Title: Audit Script for 'Take ownership of files or other objects' Policy
# Description: This script checks if the 'Take ownership of files or other objects' policy is set to 'Administrators'.

Write-Host "Starting Audit: 'Take ownership of files or other objects' policy" -ForegroundColor Green

# Export current security policy to a temporary file
secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null

# Read the current setting for 'Take ownership of files or other objects' policy
$currentOwnershipPolicy = (Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeTakeOwnershipPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "Administrators"

# Compare the current setting with the expected value
if ($currentOwnershipPolicy -eq $expectedAccounts) {
    Write-Host "PASS: 'Take ownership of files or other objects' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Take ownership of files or other objects' policy is set to: $currentOwnershipPolicy. It should be set to 'Administrators'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

