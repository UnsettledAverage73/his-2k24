# remedi.ps1

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "ProcessCreationIncludeCmdLine_Enabled"
$valueData = 1

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

Write-Output "'Include command line in process creation events' has been set to 'Enabled'."
