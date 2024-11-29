# Remedi.ps1 - Configure 'Network access: Sharing and security model for local accounts' to 'Classic - local users authenticate as themselves'

$title = "CIS Control 2.3.10.12 - Ensure 'Network access: Sharing and security model for local accounts' is set to 'Classic - local users authenticate as themselves'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "ForceGuest"
$expectedValue = 0

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 0 (Classic model)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. ForceGuest set to 0 (Classic model)"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

