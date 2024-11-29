# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions\DenyDeviceIDs"
$deviceID = "PCI\CC_0C0A"

# Check if the registry path exists
if (Test-Path $registryPath) {
    $currentDeviceIDs = Get-ChildItem -Path $registryPath | ForEach-Object { $_.GetValue("") }
    if ($currentDeviceIDs -contains $deviceID) {
        Write-Output "The device ID 'PCI\CC_0C0A' is already included in the configuration, which is compliant."
    } else {
        Write-Output "The device ID 'PCI\CC_0C0A' is NOT included in the configuration."
    }
} else {
    Write-Output "The registry path for 'Prevent installation of devices that match any of these device IDs' does not exist."
}
