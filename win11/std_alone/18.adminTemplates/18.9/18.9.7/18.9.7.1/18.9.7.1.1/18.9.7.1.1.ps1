# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
$valueName = "DenyDeviceIDs"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Prevent installation of devices that match any of these device IDs' is set to Enabled, which is compliant."
    } else {
        Write-Output "'Prevent installation of devices that match any of these device IDs' is not set to Enabled. Current value: $($value.$valueName)."
    }
} else {
    Write-Output "'Prevent installation of devices that match any of these device IDs' is not configured. Registry key does not exist."
}
