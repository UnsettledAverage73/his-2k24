# Remedi.ps1 - Configure 'User Account Control: Admin Approval Mode for the Built-in Administrator account' to 'Enabled'

$title = "CIS Control 2.3.17.1 - Ensure 'User Account Control: Admin Approval Mode for the Built-in Administrator account' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "FilterAdministratorToken"
$expectedValue = 1

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'Enabled' (value = 1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. Admin Approval Mode for the Built-in Administrator account enabled."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

