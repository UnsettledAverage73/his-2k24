# remedi.ps1
# Script to set "Configure Offer Remote Assistance" to Disabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$regValue = "fAllowUnsolicited"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 0 (Disabled)
Set-ItemProperty -Path $regPath -Name $regValue -Value 0 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 0) {
    Write-Output "'Configure Offer Remote Assistance' has been successfully set to Disabled."
} else {
    Write-Output "ERROR: Failed to set 'Configure Offer Remote Assistance' to Disabled."
}
