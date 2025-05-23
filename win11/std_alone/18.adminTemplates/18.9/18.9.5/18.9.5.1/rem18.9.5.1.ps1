# remedi.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "EnableVirtualizationBasedSecurity"
$valueData = 1

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

Write-Output "'Turn On Virtualization Based Security' has been set to 'Enabled'."
