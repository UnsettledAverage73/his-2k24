# Remedi.ps1 - Configure 'System objects: Require case insensitivity for non-Windows subsystems' to 'Enabled'

$title = "CIS Control 2.3.15.1 - Ensure 'System objects: Require case insensitivity for non-Windows subsystems' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel"
$regKey = "ObCaseInsensitive"
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
    Write-Host "$title - Remediation completed. Case insensitivity for non-Windows subsystems is now enabled."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

