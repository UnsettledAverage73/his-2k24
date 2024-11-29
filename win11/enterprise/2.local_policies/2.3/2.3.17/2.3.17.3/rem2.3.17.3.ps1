# Remedi.ps1 - Configure 'User Account Control: Behavior of the elevation prompt for standard users' to 'Automatically deny elevation requests'

$title = "CIS Control 2.3.17.3 - Ensure 'User Account Control: Behavior of the elevation prompt for standard users' is set to 'Automatically deny elevation requests'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "ConsentPromptBehaviorUser"
$expectedValue = 0  # 0 = Automatically deny elevation requests

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Automatically deny elevation requests' (value = 0)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Behavior of the elevation prompt for standard users is now set to 'Automatically deny elevation requests'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

