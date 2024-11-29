# remedi.ps1
# Script to disable Font Providers

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$RegKey = "EnableFontProviders"

# Ensure the registry key exists and set its value to 0 (disable font providers)
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 0 (disable font providers)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 0 -Type DWord

# Verify the change
$value = Get-ItemProperty -Path $RegPath -Name $RegKey | Select-Object -ExpandProperty $RegKey
if ($value -eq 0) {
    Write-Output "Remediation successful: Font Providers are disabled."
} else {
    Write-Output "Remediation failed: Unable to disable Font Providers."
}
