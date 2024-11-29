# remedi.ps1
# Script to disable 'Store passwords using reversible encryption'

Write-Host "Disabling 'Store passwords using reversible encryption'..." -ForegroundColor Cyan

# Set the policy value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name 'StoreClearTextPasswords' -Value 0 -Type DWord

# Verify the change
$storePasswords = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa").'StoreClearTextPasswords'

if ($storePasswords -eq 0 -or $storePasswords -eq $null) {
    Write-Host "'Store passwords using reversible encryption' successfully disabled." -ForegroundColor Green
} else {
    Write-Host "Failed to disable 'Store passwords using reversible encryption'. Current value: $storePasswords." -ForegroundColor Red
}
