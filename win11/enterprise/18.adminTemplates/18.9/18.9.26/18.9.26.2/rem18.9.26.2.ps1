# remedi.ps1
# Script to set 'Configures LSASS to run as a protected process' to 'Enabled with UEFI Lock'

# Registry path and key
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$RegKey = "RunAsPPL"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value to 1 (Enabled with UEFI Lock)
Set-ItemProperty -Path $RegPath -Name $RegKey -Value 1 -Type DWord
Write-Output "'Configures LSASS to run as a protected process' is now set to 'Enabled with UEFI Lock'."

# Verify the remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $RegKey

if ($CurrentValue -eq 1) {
    Write-Output "Verification successful: 'Configures LSASS to run as a protected process' is set to 'Enabled with UEFI Lock'."
} else {
    Write-Output "Verification failed: $RegKey is set to $CurrentValue. Expected value: 1."
}
