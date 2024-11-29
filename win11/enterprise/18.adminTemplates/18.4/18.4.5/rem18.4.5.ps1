# Remedi.ps1 - Configure 'Enable Certificate Padding' to 'Enabled'

$title = "CIS Control 18.4.5 (L1) - Ensure 'Enable Certificate Padding' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Cryptography\Wintrust\Config"
$regKey = "EnableCertPaddingCheck"
$expectedValue = 1  # 1 = Enabled

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Enabled' (value = 1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. 'Enable Certificate Padding' is now Enabled."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

