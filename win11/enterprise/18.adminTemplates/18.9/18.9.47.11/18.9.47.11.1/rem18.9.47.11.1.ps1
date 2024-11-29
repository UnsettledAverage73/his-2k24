# remedi.ps1
# Script to set "Enable/Disable PerfTrack" to Disabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WDI"
$regValue = "{9c5a40da-b965-4fc3-878188dd50a6299d}:ScenarioExecutionEnabled"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 0 (Disabled)
Set-ItemProperty -Path $regPath -Name $regValue -Value 0 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 0) {
    Write-Output "'Enable/Disable PerfTrack' has been successfully set to Disabled."
} else {
    Write-Output "ERROR: Failed to set 'Enable/Disable PerfTrack' to Disabled."
}
