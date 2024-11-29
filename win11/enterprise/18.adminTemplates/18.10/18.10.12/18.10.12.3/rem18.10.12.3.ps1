# remedi.ps1
# Script to set "Turn off Microsoft consumer experiences" to Enabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
$regValue = "DisableWindowsConsumerFeatures"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 1 (Enabled)
Set-ItemProperty -Path $regPath -Name $regValue -Value 1 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 1) {
    Write-Output "'Turn off Microsoft consumer experiences' has been successfully set to Enabled."
} else {
    Write-Output "Failed to set 'Turn off Microsoft consumer experiences' to Enabled."
}
