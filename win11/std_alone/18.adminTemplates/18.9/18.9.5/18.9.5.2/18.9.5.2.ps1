# check.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "RequirePlatformSecurityFeatures"

# Check if the registry key and value exist
if (Test-Path $registryPath) {
    $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    switch ($value.$valueName) {
        1 { Write-Output "'Turn On Virtualization Based Security: Select Platform Security Level' is set to 'Secure Boot', which is compliant." }
        3 { Write-Output "'Turn On Virtualization Based Security: Select Platform Security Level' is set to 'Secure Boot and DMA Protection', which is compliant." }
        default { Write-Output "'Turn On Virtualization Based Security: Select Platform Security Level' is set to an unrecognized value: $($value.$valueName)." }
    }
} else {
    Write-Output "'Turn On Virtualization Based Security: Select Platform Security Level' is not configured. Registry key does not exist."
}
