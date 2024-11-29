# Title: Audit Script for 'Deny access to this computer from the network' Policy
# Description: This script checks if the 'Deny access to this computer from the network' policy includes 'Guests' and 'Local account' as per CIS recommendations.

Write-Host "Starting Audit: 'Deny access to this computer from the network' policy" -ForegroundColor Green

# Define the expected values
$expectedAccounts = @("Guests", "Local account")

# Retrieve the current policy setting
$currentAccounts = (secedit /export /areas USER_RIGHTS /cfg "$env:TEMP\secedit-output.inf" | Out-Null; 
                    Select-String -Path "$env:TEMP\secedit-output.inf" -Pattern "SeDenyNetworkLogonRight").ToString().Split('=')[1].Trim().Split(',')

# Compare the current accounts with the expected accounts
$missingAccounts = $expectedAccounts | Where-Object { $_ -notin $currentAccounts }

if ($missingAccounts.Count -eq 0) {
    Write-Host "PASS: 'Deny access to this computer from the network' policy includes 'Guests' and 'Local account'." -ForegroundColor Green
} else {
    Write-Host "FAIL: The following accounts are missing from the policy: $missingAccounts" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

