# remedi.ps1
# Script to enable 'Prohibit access of the Windows Connect Now wizards'

# Registry path and key
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WCN\UI"
$RegKey = "DisableWcnUi"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 1 (Enabled)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 1 -Type DWord
Write-Output "'Prohibit access of the Windows Connect Now wizards' is now enabled."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Verification successful: 'Prohibit access of the Windows Connect Now wizards' is enabled."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 1."
}
