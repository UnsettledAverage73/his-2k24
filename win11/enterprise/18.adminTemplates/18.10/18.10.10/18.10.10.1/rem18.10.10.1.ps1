# remedi.ps1
# Script to set "Allow Use of Camera" to Disabled

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Camera"
$regValue = "AllowCamera"

# Ensure the registry path exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value to 0 (Disabled)
Set-ItemProperty -Path $regPath -Name $regValue -Value 0 -Type DWord

# Verify the setting
$value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
if ($value.$regValue -eq 0) {
    Write-Output "'Allow Use of Camera' has been successfully set to Disabled."
} else {
    Write-Output "Failed to set 'Allow Use of Camera' to Disabled."
}
