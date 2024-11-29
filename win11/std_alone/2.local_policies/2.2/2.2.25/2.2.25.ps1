# Title: Audit Script for 'Increase scheduling priority' Policy
# Description: This script checks if the 'Increase scheduling priority' policy is set to 'Administrators, Window Manager\Window Manager Group' as per CIS recommendations.

Write-Host "Starting Audit: 'Increase scheduling priority' policy" -ForegroundColor Green

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeIncreaseBasePriorityPrivilege").ToString().Split('=')[1].Trim()

# Expected value
$expectedAccounts = "*S-1-5-32-544,*S-1-5-90-0" # SIDs for Administrators and Window Manager\Window Manager Group

# Check if the policy matches the expected value
if ($currentAccounts -eq $expectedAccounts) {
    Write-Host "PASS: 'Increase scheduling priority' policy is correctly set to 'Administrators, Window Manager\Window Manager Group'." -ForegroundColor Green
} else {
    Write-Host "FAIL: 'Increase scheduling priority' policy is set to: $currentAccounts. It should be 'Administrators, Window Manager\Window Manager Group'." -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

