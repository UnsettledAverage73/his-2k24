# Remedi.ps1 - Configure 'User Account Control: Switch to the secure desktop when prompting for elevation' to 'Enabled'

$title = "CIS Control 2.3.17.7 - Ensure 'User Account Control: Switch to the secure desktop when prompting for elevation' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "PromptOnSecureDesktop"
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
    Write-Host "$title - Remediation completed. Elevation prompts will now switch to the secure desktop."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

