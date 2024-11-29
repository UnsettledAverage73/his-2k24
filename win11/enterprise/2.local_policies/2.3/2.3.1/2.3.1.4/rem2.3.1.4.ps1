# Title: Remediation Script for 'Accounts: Rename administrator account' Policy
# Description: This script renames the built-in Administrator account to a specified new name.

Write-Host "Starting Remediation: Configuring 'Accounts: Rename administrator account' policy" -ForegroundColor Yellow

# Specify the new name for the Administrator account
$newAdminName = "CustomAdminName" # Replace 'CustomAdminName' with your desired name

# Rename the Administrator account
try {
    $adminAccount = Get-LocalUser | Where-Object { $_.SID -eq "S-1-5-21-*-500" }
    if ($adminAccount -ne $null) {
        if ($adminAccount.Name -ne $newAdminName) {
            Write-Host "Renaming the Administrator account to '$newAdminName'..." -ForegroundColor Cyan
            Rename-LocalUser -Name $adminAccount.Name -NewName $newAdminName
            Write-Host "SUCCESS: The built-in Administrator account has been renamed to '$newAdminName'." -ForegroundColor Green
        } else {
            Write-Host "The Administrator account is already named '$newAdminName'. No changes needed." -ForegroundColor Green
        }
    } else {
        Write-Host "ERROR: Administrator account not found." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: Failed to rename the Administrator account. $_" -ForegroundColor Red
}

Write-Host "Remediation Completed." -ForegroundColor Yellow

