# remedi.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "HypervisorEnforcedCodeIntegrity"
$valueData = 2 # 2 corresponds to "Enabled with UEFI lock"

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Output the result
if ($valueData -eq 2) {
    Write-Output "'Turn On Virtualization Based Security: Virtualization Based Protection of Code Integrity' has been set to 'Enabled with UEFI lock'."
}
