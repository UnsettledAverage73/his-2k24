# remedi.ps1
# Script to set "Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider" to Disabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy"
$regValue = "DisableQueryRemoteServer"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 1 (Disabled)
Set-ItemProperty -Path $regPath -Name $regValue -Value 1 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 1) {
    Write-Output "'Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider' has been successfully set to Disabled."
} else {
    Write-Output "ERROR: Failed to set 'Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider' to Disabled."
}
