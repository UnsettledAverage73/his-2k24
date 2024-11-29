# Remedi.ps1 - Configure 'Allow Online Tips' to 'Disabled'

$title = "CIS Control 18.1.3 (L2) - Ensure 'Allow Online Tips' is set to 'Disabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$regKey = "AllowOnlineTips"
$expectedValue = 0  # 0 = Disabled

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Disabled' (value = 0)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Online Tips are now disabled."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

