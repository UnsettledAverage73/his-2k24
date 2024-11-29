# Title: Audit Script for 'Generate security audits' Policy
# Description: This script checks if the 'Generate security audits' policy is set to 'LOCAL SERVICE, NETWORK SERVICE' as per CIS recommendations.

Write-Host "Starting Audit: 'Generate security audits' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeAuditPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "*S-1-5-19,*S-1-5-20" # LOCAL SERVICE (S-1-5-19) and NETWORK SERVICE (S-1-5-20)

# Check if the policy matches the expected value
if ($currentAccounts -eq $expectedAccounts) {
    Write-Host "PASS: 'Generate security audits' policy is correctly set to 'LOCAL SERVICE, NETWORK SERVICE'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Generate security audits' policy is set to: $currentAccounts. It should be 'LOCAL SERVICE, NETWORK SERVICE'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

