# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "HVCIMATRequired"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Turn On Virtualization Based Security: Require UEFI Memory Attributes Table' is set to True (checked), which is compliant."
    } else {
        Write-Output "'Turn On Virtualization Based Security: Require UEFI Memory Attributes Table' is not set to True. Current value: $($value.$valueName)."
    }
} else {
    Write-Output "'Turn On Virtualization Based Security: Require UEFI Memory Attributes Table' is not configured. Registry key does not exist."
}
