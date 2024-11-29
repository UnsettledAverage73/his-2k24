# Remedi.ps1 - Configure 'Prevent enabling lock screen slide show' to 'Enabled'

$title = "CIS Control 18.1.1.2 - Ensure 'Prevent enabling lock screen slide show' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$regKey = "NoLockScreenSlideshow"
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
    Write-Host "$title - Remediation completed. Lock screen slide show is now disabled."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

