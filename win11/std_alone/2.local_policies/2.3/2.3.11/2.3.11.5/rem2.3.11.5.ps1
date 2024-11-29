# Remedi.ps1 - Configure 'Network security: Do not store LAN Manager hash value on next password change' to 'Enabled'

$title = "CIS Control 2.3.11.5 - Ensure 'Network security: Do not store LAN Manager hash value on next password change' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "NoLMHash"
$expectedValue = 1

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the recommended configuration (Enabled)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. NoLMHash set to 1 (LAN Manager hash value will not be stored)"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

