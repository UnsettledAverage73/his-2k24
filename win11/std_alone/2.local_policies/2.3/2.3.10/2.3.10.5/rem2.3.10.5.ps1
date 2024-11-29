# Remedi.ps1 - Configure Network access: Let Everyone permissions apply to anonymous users to 'Disabled'

$title = "CIS Control 2.3.10.5 - Ensure 'Network access: Let Everyone permissions apply to anonymous users' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$regKey = "EveryoneIncludesAnonymous"

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to Disabled (0)
    Set-ItemProperty -Path $regPath -Name $regKey -Value 0 -Force
    Write-Host "$title - Remediation completed. Setting 'Network access: Let Everyone permissions apply to anonymous users' to 'Disabled'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

