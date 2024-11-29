# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "HypervisorEnforcedCodeIntegrity"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    switch ($value.$valueName) {
        1 { Write-Output "'Turn On Virtualization Based Security: Virtualization Based Protection of Code Integrity' is set to 'Enabled', which is not UEFI-locked." }
        2 { Write-Output "'Turn On Virtualization Based Security: Virtualization Based Protection of Code Integrity' is set to 'Enabled with UEFI lock', which is compliant." }
        default { Write-Output "'Turn On Virtualization Based Security: Virtualization Based Protection of Code Integrity' is set to an unrecognized value: $($value.$valueName)." }
    }
} else {
    Write-Output "'Turn On Virtualization Based Security: Virtualization Based Protection of Code Integrity' is not configured. Registry key does not exist."
}
