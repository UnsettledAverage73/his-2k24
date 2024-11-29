# remedi.ps1
# Script to set "Allow network connectivity during connected-standby (plugged in)" to Disabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9"
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
    Write-Output "'Allow network connectivity during connected-standby (plugged in)' has been successfully set to Disabled."
} else {
    Write-Output "ERROR: Failed to set 'Allow network connectivity during connected-standby (plugged in)' to Disabled."
}
