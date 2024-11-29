# Remedi.ps1 - Configure 'Network security: LDAP client signing requirements' to 'Negotiate signing' or higher

$title = "CIS Control 2.3.11.8 - Ensure 'Network security: LDAP client signing requirements' is set to 'Negotiate signing' or higher"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LDAP"
$regKey = "LDAPClientIntegrity"
$expectedValue = 1

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the recommended configuration (Negotiate signing)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. LDAP client signing set to 'Negotiate signing'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

