# Remedi.ps1 - Configure 'Network security: Configure encryption types allowed for Kerberos' to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'

$title = "CIS Control 2.3.11.4 - Ensure 'Network security: Configure encryption types allowed for Kerberos' is set to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters"
$regKey = "SupportedEncryptionTypes"
$expectedValue = 2147483640

Write-Host "Remediating: $title"

# Ensure the registry path exists
try {
    if (-not (Test-Path -Path $regPath)) {
        Write-Host "Registry path does not exist. Creating path..."
        New-Item -Path $regPath -Force | Out-Null
    }

    # Set the registry value to the recommended configuration (AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types)
    Set-ItemProperty -Path $regPath -Name $regKey -Value $expectedValue -Type DWord
    Write-Host "$title - Remediation completed. SupportedEncryptionTypes set to 2147483640 (AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types)"
} catch {
    Write-Host "$title - Remediation failed. Error: $_"
}

