# Title: Audit Script for 'Perform volume maintenance tasks' and 'Profile single process' Policies
# Description: This script checks if the 'Perform volume maintenance tasks' and 'Profile single process' policies are set to 'Administrators'.

Write-Host "Starting Audit: 'Perform volume maintenance tasks' and 'Profile single process' policies" -ForegroundColor Green

# Check 'Perform volume maintenance tasks' policy
$currentVolumeMaintenance = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                              Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeManageVolumePrivilege").ToString().Split('=')[1].Trim()

# Check 'Profile single process' policy
$currentProfileProcess = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                           Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeProfileSingleProcessPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "Administrators"

# Check if both policies match the expected value
if ($currentVolumeMaintenance -eq $expectedAccounts) {
    Write-Host "PASS: 'Perform volume maintenance tasks' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Perform volume maintenance tasks' policy is set to: $currentVolumeMaintenance. It should be set to 'Administrators'." -ForegroundColor Red
}

if ($currentProfileProcess -eq $expectedAccounts) {
    Write-Host "PASS: 'Profile single process' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Profile single process' policy is set to: $currentProfileProcess. It should be set to 'Administrators'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

