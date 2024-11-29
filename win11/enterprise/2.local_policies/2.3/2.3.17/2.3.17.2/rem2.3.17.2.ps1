# Remedi.ps1 - Configure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' to 'Prompt for consent on the secure desktop' or higher

$title = "CIS Control 2.3.17.2 - Ensure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to 'Prompt for consent on the secure desktop' or higher"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "ConsentPromptBehaviorAdmin"
$expectedValue = 1  # 1 = Prompt for consent on the secure desktop, 2 = Prompt for credentials on the secure desktop

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Prompt for consent on the secure desktop' (value = 1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Behavior of the elevation prompt for administrators is now set to 'Prompt for consent on the secure desktop'."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

