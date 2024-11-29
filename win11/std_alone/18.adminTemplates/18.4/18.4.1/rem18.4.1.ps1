# Remedi.ps1 - Configure 'Apply UAC restrictions to local accounts on network logons' to 'Enabled'

$title = "CIS Control 18.4.1 (L1) - Ensure 'Apply UAC restrictions to local accounts on network logons' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "LocalAccountTokenFilterPolicy"
$expectedValue = 0  # 0 = Enabled

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Enabled' (value = 0)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. UAC restrictions are now applied to local accounts on network logons."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

