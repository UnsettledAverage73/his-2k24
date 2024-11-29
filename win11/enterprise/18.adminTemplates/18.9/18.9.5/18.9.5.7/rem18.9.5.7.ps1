# remedi.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "ConfigureKernelShadowStacksLaunch"
$valueData = 1 # 1 corresponds to "Enabled in enforcement mode"

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Output the result
if ($valueData -eq 1) {
    Write-Output "'Turn On Virtualization Based Security: Kernel-mode Hardware-enforced Stack Protection' has been set to Enabled in enforcement mode."
}
