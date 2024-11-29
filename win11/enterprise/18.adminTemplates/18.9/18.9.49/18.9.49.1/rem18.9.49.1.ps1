# remedi.ps1
# Script to set "Turn off the advertising ID" to Enabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
$regValue = "DisabledByGroupPolicy"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 1 (Enabled)
Set-ItemProperty -Path $regPath -Name $regValue -Value 1 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 1) {
    Write-Output "'Turn off the advertising ID' has been successfully set to Enabled."
} else {
    Write-Output "ERROR: Failed to set 'Turn off the advertising ID' to Enabled."
}
