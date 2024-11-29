# Remedi.ps1 - Configure Network access: Do not allow anonymous enumeration of SAM accounts and shares to 'Enabled'

$title = "CIS Control 2.3.10.3 - Ensure 'Network access: Do not allow anonymous enumeration of SAM accounts and shares' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "RestrictAnonymous"

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to Enabled (1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value 1 -Force
    Write-Host "$title - Remediation completed. Setting 'Network access: Do not allow anonymous enumeration of SAM accounts and shares' to 'Enabled'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

