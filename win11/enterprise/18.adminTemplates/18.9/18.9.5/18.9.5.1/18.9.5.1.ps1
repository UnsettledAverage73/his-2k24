# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "EnableVirtualizationBasedSecurity"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Turn On Virtualization Based Security' is correctly set to 'Enabled'."
    } elseif ($value.$valueName -eq 0) {
        Write-Output "'Turn On Virtualization Based Security' is set to 'Disabled', which is not recommended."
    } else {
        Write-Output "'Turn On Virtualization Based Security' is not configured as recommended. Current Value: $($value.$valueName)"
    }
} else {
    Write-Output "'Turn On Virtualization Based Security' is not configured. Registry key does not exist."
}
