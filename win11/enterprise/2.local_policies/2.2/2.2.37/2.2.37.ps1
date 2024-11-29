# Title: Audit Script for 'Restore files and directories' Policy
# Description: This script checks if the 'Restore files and directories' policy is set to 'Administrators'.

Write-Host "Starting Audit: 'Restore files and directories' policy" -ForegroundColor Green

# Check 'Restore files and directories' policy
$currentRestoreFilesPolicy = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                               Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeRestorePrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "Administrators"

# Check if the policy matches the expected value
if ($currentRestoreFilesPolicy -eq $expectedAccounts) {
    Write-Host "PASS: 'Restore files and directories' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Restore files and directories' policy is set to: $currentRestoreFilesPolicy. It should be set to 'Administrators'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

