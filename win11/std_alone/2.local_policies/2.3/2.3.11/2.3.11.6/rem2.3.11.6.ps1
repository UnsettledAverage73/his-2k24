# Remedi.ps1 - Configure 'Network security: Force logoff when logon hours expire' to 'Enabled'

$title = "CIS Control 2.3.11.6 - Ensure 'Network security: Force logoff when logon hours expire' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "DisableLogoffWhenLogonHoursExpire"
$expectedValue = 0

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the recommended configuration (Enabled)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Force logoff enabled when logon hours expire."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

