# remedi.ps1
# Script to set "Allow standby states (S1-S3) when sleeping (plugged in)" to Disabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\abfc2519-3608-4c2a-94ea171b0ed546ab"
$regValue = "ACSettingIndex"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 0 (Disabled)
Set-ItemProperty -Path $regPath -Name $regValue -Value 0 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 0) {
    Write-Output "'Allow standby states (S1-S3) when sleeping (plugged in)' has been successfully set to Disabled."
} else {
    Write-Output "ERROR: Failed to set 'Allow standby states (S1-S3) when sleeping (plugged in)' to Disabled."
}
