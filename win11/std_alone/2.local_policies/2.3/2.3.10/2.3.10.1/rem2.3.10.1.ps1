# Remedi.ps1 - Configure Network access: Allow anonymous SID/Name translation to 'Disabled'

$title = "CIS Control 2.3.10.1 - Ensure 'Network access: Allow anonymous SID/Name translation' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "TurnOffAnonymousBlock"

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to Disabled (1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Force
    Write-Host "$title - Remediation completed. Setting 'Network access: Allow anonymous SID/Name translation' to 'Disabled'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

