# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions"
$valueName = "DenyDeviceIDsRetroactive"

# Check if the registry key exists
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value -and $value.$valueName -eq 1) {
        Write-Output "The policy 'Also apply to matching devices that are already installed' is enabled (True)."
    } else {
        Write-Output "The policy 'Also apply to matching devices that are already installed' is NOT enabled (False)."
    }
} else {
    Write-Output "The registry path does not exist. The policy is not configured."
}
