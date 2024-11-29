# Title: Audit Script for 'Profile system performance' Policy
# Description: This script checks if the 'Profile system performance' policy is set to 'Administrators, NT SERVICE\WdiServiceHost'.

Write-Host "Starting Audit: 'Profile system performance' policy" -ForegroundColor Green

# Check 'Profile system performance' policy
$currentProfilePerformance = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                               Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeSystemProfilePrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "Administrators, NT SERVICE\WdiServiceHost"

# Check if the policy matches the expected value
if ($currentProfilePerformance -eq $expectedAccounts) {
    Write-Host "PASS: 'Profile system performance' policy is correctly set to 'Administrators, NT SERVICE\WdiServiceHost'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Profile system performance' policy is set to: $currentProfilePerformance. It should be set to 'Administrators, NT SERVICE\WdiServiceHost'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

