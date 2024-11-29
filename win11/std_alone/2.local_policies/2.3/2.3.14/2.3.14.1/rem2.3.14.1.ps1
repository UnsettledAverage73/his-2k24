# Remedi.ps1 - Configure 'System cryptography: Force strong key protection for user keys stored on the computer' to 'User is prompted when the key is first used' or higher

$title = "CIS Control 2.3.14.1 - Ensure 'System cryptography: Force strong key protection for user keys stored on the computer' is set to 'User is prompted when the key is first used' or higher"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Cryptography"
$regKey = "ForceKeyProtection"
$expectedValue = 1

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to 'User is prompted when the key is first used' (value = 1)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. User is now prompted when the key is first used."
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

