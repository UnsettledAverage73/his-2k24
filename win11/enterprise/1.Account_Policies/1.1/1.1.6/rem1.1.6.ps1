# remedi.ps1
# Script to enable 'Relax minimum password length limits'

Write-Host "Enabling 'Relax minimum password length limits'..." -ForegroundColor Cyan

# Set the policy value
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\SAM" -Name 'RelaxMinimumPasswordLengthLimits' -Value 1 -Type DWord

# Verify the change
$relaxPwdLength = (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\SAM").'RelaxMinimumPasswordLengthLimits'

if ($relaxPwdLength -eq 1) {
    Write-Host "'Relax minimum password length limits' successfully enabled." -ForegroundColor Green
} else {
    Write-Host "Failed to enable 'Relax minimum password length limits'. Current value: $relaxPwdLength." -ForegroundColor Red
}
