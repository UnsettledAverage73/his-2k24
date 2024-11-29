# Remedi.ps1 - Configure 'Network access: Restrict clients allowed to make remote calls to SAM' to 'Administrators: Remote Access: Allow'

$title = "CIS Control 2.3.10.10 - Ensure 'Network access: Restrict clients allowed to make remote calls to SAM' is set to 'Administrators: Remote Access: Allow'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "restrictremotesam"
$expectedValue = "O:BAG:BAD:(A;;RC;;;BA)"

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type String
    Write-Host "$title - Remediation completed. Value set to: $expectedValue"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

