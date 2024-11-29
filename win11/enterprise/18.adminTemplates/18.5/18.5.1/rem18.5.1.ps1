# Remedi.ps1 - Disable 'AutoAdminLogon'

$title = "CIS Control 18.5.1 (L1) - Ensure 'MSS: (AutoAdminLogon) Enable Automatic Logon' is set to 'Disabled'"
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regKey = "AutoAdminLogon"
$expectedValue = 0  # Disabled

Write-Host "Remediating: $title"

try {
    # Ensure the registry path exists
    if (-not (Test-Path $regPath)) {
        Write-Host "Registry path does not exist. Creating it..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry key to the recommended value
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type String
    Write-Host "$title - Remediation completed. AutoAdminLogon is now disabled (value: 0)."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

