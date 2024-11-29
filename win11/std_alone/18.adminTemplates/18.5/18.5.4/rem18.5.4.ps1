# Remedi.ps1 - Configure 'DisableSavePassword' to Enabled

$title = "CIS Control 18.5.4 (L2) - Ensure 'MSS: (DisableSavePassword) Prevent the Dial-Up Password from Being Saved' is set to 'Enabled'"
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\RasMan\Parameters"
$regKey = "DisableSavePassword"
$expectedValue = 1  # Enabled

Write-Host "Remediating: $title"

try {
    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path does not exist. Creating it..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry key to the recommended value
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Dial-up password saving is now disabled (value: 1)."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

