# remedi.ps1

# Define the registry path and value to set
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
$valueName = "DenyDeviceIDsRetroactive"
$valueData = 1

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Output the result
Write-Output "The policy 'Also apply to matching devices that are already installed' has been enabled (True)."
