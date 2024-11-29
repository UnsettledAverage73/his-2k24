# remedi.ps1
# Script to set "Require a password when a computer wakes (plugged in)" to Enabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5f7d2daa51f51"
$regValue = "ACSettingIndex"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 1 (Enabled)
Set-ItemProperty -Path $regPath -Name $regValue -Value 1 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 1) {
    Write-Output "'Require a password when a computer wakes (plugged in)' has been successfully set to Enabled."
} else {
    Write-Output "ERROR: Failed to set 'Require a password when a computer wakes (plugged in)' to Enabled."
}
