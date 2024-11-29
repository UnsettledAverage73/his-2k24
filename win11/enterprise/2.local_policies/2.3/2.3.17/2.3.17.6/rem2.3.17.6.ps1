# Remedi.ps1 - Configure 'User Account Control: Run all administrators in Admin Approval Mode' to 'Enabled'

$title = "CIS Control 2.3.17.6 - Ensure 'User Account Control: Run all administrators in Admin Approval Mode' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "EnableLUA"
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
    Write-Host "$title - Remediation completed. All administrators will now run in Admin Approval Mode."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

