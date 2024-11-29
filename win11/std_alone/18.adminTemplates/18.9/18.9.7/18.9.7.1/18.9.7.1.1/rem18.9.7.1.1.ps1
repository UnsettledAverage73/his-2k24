# remedi.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
$valueName = "DenyDeviceIDs"
$valueData = 1 # 1 corresponds to "Enabled"

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Output the result
if ($valueData -eq 1) {
    Write-Output "'Prevent installation of devices that match any of these device IDs' has been set to Enabled."
}
