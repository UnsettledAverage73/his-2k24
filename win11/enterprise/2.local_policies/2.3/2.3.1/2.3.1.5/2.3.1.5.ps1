# Title: Audit Script for 'Accounts: Rename guest account' Policy
# Description: This script checks if the built-in Guest account has been renamed.

Write-Host "Starting Audit: 'Accounts: Rename guest account' policy" -ForegroundColor Green

# Retrieve the current name of the Guest account
try {
    $currentGuestName = (Get-LocalUser | Where-Object { $_.SID -eq "S-1-5-21-*-501" }).Name
    if ($currentGuestName -ne "Guest") {
        Write-Host "PASS: The built-in Guest account has been renamed to '$currentGuestName'." -ForegroundColor Green
    } else {
        Write-Host "FAIL: The built-in Guest account has not been renamed. It is still named 'Guest'." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: Failed to retrieve the Guest account details. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

