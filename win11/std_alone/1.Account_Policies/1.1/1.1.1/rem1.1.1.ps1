# remedi.ps1
# Script to set 'Enforce password history' to 24

Write-Host "Setting 'Enforce password history' to 24..." -ForegroundColor Cyan

# Set the policy value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters" -Name 'PasswordHistorySize' -Value 24

# Verify the change
$passwordHistory = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters").'PasswordHistorySize'

if ($passwordHistory -eq 24) {
    Write-Host "'Enforce password history' successfully set to $passwordHistory passwords remembered." -ForegroundColor Green
} else {
    Write-Host "Failed to set 'Enforce password history'. Current value is $passwordHistory." -ForegroundColor Red
}
