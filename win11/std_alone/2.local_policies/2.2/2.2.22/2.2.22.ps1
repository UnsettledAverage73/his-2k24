# Title: Audit Script for 'Force shutdown from a remote system' Policy
# Description: This script checks if the 'Force shutdown from a remote system' policy is set to 'Administrators' as per CIS recommendations.

Write-Host "Starting Audit: 'Force shutdown from a remote system' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeRemoteShutdownPrivilege").ToString().Split('=')[1].Trim()

# Check if the policy is set to 'Administrators'
if ($currentAccounts -eq "*S-1-5-32-544") {
    Write-Host "PASS: 'Force shutdown from a remote system' policy is correctly set to 'Administrators'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Force shutdown from a remote system' policy is set to: $currentAccounts. It should be 'Administrators'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

