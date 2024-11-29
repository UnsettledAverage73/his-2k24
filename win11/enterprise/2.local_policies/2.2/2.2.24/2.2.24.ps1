# Title: Audit Script for 'Impersonate a client after authentication' Policy
# Description: This script checks if the 'Impersonate a client after authentication' policy is set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE' as per CIS recommendations.

Write-Host "Starting Audit: 'Impersonate a client after authentication' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeImpersonatePrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "*S-1-5-32-544,*S-1-5-19,*S-1-5-20,*S-1-5-6" # SIDs for Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE

# Check if the policy matches the expected value
if ($currentAccounts -eq $expectedAccounts) {
    Write-Host "PASS: 'Impersonate a client after authentication' policy is correctly set to 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Impersonate a client after authentication' policy is set to: $currentAccounts. It should be 'Administrators, LOCAL SERVICE, NETWORK SERVICE, SERVICE'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

