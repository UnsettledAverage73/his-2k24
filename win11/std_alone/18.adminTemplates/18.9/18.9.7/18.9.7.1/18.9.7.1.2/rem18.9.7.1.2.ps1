# remedi.ps1

# Define the registry path and device ID to configure
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceIDs"
$deviceID = "PCI\CC_0C0A"

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Check for existing device ID list and add the required ID if not present
$currentDeviceIDs = Get-ChildItem -Path $registryPath | ForEach-Object { $_.GetValue("") }
if (-not ($currentDeviceIDs -contains $deviceID)) {
    # Add the
    
}