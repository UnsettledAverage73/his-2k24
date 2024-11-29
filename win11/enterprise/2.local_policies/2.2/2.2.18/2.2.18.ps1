# Title: Audit Script for 'Deny log on as a service' Policy
# Description: This script checks if the 'Deny log on as a service' policy includes 'Guests' as per CIS recommendations.

Write-Host "Starting Audit: 'Deny log on as a service' policy" -ForegroundColor Green

# Define the expected value
$expectedAccounts = @("Guests")

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeDenyServiceLogonRight").ToString().Split('=')[1].Trim().Split(',')

# Compare the current accounts with the expected accounts
$missingAccounts = $expectedAccounts | Where-Object { $_ -notin $currentAccounts }

if ($missingAccounts.Count -eq 0) {
    Write-Host "PASS: 'Deny log on as a service' policy includes 'Guests'." -ForegroundColor Green
} else {
    Write-Host "FAIL: The following accounts are missing from the policy: $missingAccounts" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

