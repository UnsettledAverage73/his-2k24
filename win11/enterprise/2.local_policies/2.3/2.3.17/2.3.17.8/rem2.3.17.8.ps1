# Remedi.ps1 - Configure 'User Account Control: Virtualize file and registry write failures to per-user locations' to 'Enabled'

$title = "CIS Control 2.3.17.8 - Ensure 'User Account Control: Virtualize file and registry write failures to per-user locations' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "EnableVirtualization"
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
    Write-Host "$title - Remediation completed. Application write failures will now be virtualized to per-user locations."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

