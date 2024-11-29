# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "LsaCfgFlags"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($value.$valueName -eq 1) {
        Write-Output "'Turn On Virtualization Based Security: Credential Guard Configuration' is set to Enabled with UEFI lock, which is compliant."
    } else {
        Write-Output "'Turn On Virtualization Based Security: Credential Guard Configuration' is not set to Enabled with UEFI lock. Current value: $($value.$valueName)."
    }
} else {
    Write-Output "'Turn On Virtualization Based Security: Credential Guard Configuration' is not configured. Registry key does not exist."
}
