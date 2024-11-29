# Remedi.ps1 - Configure 'Network Security: Allow PKU2U authentication requests to this computer to use online identities' to 'Disabled'

$title = "CIS Control 2.3.11.3 - Ensure 'Network Security: Allow PKU2U authentication requests to this computer to use online identities' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\pku2u"
$regKey = "AllowOnlineID"
$expectedValue = 0

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 0 (Disabled)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. AllowOnlineID set to 0 (Disabled)"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

