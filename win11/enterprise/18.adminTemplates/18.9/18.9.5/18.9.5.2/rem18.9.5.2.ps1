# remedi.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "RequirePlatformSecurityFeatures"
$valueData = 1 # Change to 3 if "Secure Boot and DMA Protection" is preferred

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Output the result
if ($valueData -eq 1) {
    Write-Output "'Turn On Virtualization Based Security: Select Platform Security Level' has been set to 'Secure Boot'."
} elseif ($valueData -eq 3) {
    Write-Output "'Turn On Virtualization Based Security: Select Platform Security Level' has been set to 'Secure Boot and DMA Protection'."
}
