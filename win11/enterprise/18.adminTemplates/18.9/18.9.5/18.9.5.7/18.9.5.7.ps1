# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "ConfigureKernelShadowStacksLaunch"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Turn On Virtualization Based Security: Kernel-mode Hardware-enforced Stack Protection' is set to Enabled in enforcement mode, which is compliant."
    } else {
        Write-Output "'Turn On Virtualization Based Security: Kernel-mode Hardware-enforced Stack Protection' is not set to Enabled in enforcement mode. Current value: $($value.$valueName)."
    }
} else {
    Write-Output "'Turn On Virtualization Based Security: Kernel-mode Hardware-enforced Stack Protection' is not configured. Registry key does not exist."
}
