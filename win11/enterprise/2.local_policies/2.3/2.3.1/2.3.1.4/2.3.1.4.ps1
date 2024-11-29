# Title: Audit Script for 'Accounts: Rename administrator account' Policy
# Description: This script checks if the built-in Administrator account has been renamed.

Write-Host "Starting Audit: 'Accounts: Rename administrator account' policy" -ForegroundColor Green

# Retrieve the current name of the Administrator account
try {
    $currentAdminName = (Get-LocalUser | Where-Object { $_.SID -eq "S-1-5-21-*-500" }).Name
    if ($currentAdminName -ne "Administrator") {
        Write-Host "PASS: The built-in Administrator account has been renamed to '$currentAdminName'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: The built-in Administrator account has not been renamed. It is still named 'Administrator'." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: Failed to retrieve the Administrator account details. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

