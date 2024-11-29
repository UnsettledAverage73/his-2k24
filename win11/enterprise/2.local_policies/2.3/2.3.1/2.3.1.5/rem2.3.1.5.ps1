# Title: Remediation Script for 'Accounts: Rename guest account' Policy
# Description: This script renames the built-in Guest account to a specified new name.

Write-Host "Starting Remediation: Configuring 'Accounts: Rename guest account' policy" -ForegroundColor Yellow

# Specify the new name for the Guest account
$newGuestName = "CustomGuestName" # Replace 'CustomGuestName' with your desired name

# Rename the Guest account
try {
    $guestAccount = Get-LocalUser | Where-Object { $_.SID -eq "S-1-5-21-*-501" }
    if ($guestAccount -ne $null) {
        if ($guestAccount.Name -ne $newGuestName) {
            Write-Host "Renaming the Guest account to '$newGuestName'..." -ForegroundColor Cyan
            Rename-LocalUser -Name $guestAccount.Name -NewName $newGuestName
            Write-Host "SUCCESS: The built-in Guest account has been renamed to '$newGuestName'." -ForegroundColor Green
        } else {
            Write-Host "The Guest account is already named '$newGuestName'. No changes needed." -ForegroundColor Green
        }
    } else {
        Write-Host "ERROR: Guest account not found." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: Failed to rename the Guest account. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

