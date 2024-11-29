# Remedi.ps1 - Configure 'Network security: Allow LocalSystem NULL session fallback' to 'Disabled'

$title = "CIS Control 2.3.11.2 - Ensure 'Network security: Allow LocalSystem NULL session fallback' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$regKey = "AllowNullSessionFallback"
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
    Write-Host "$title - Remediation completed. AllowNullSessionFallback set to 0 (Disabled)"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

