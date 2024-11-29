# Check.ps1 - Verify 'Network security: Configure encryption types allowed for Kerberos' is set to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'

$title = "CIS Control 2.3.11.4 - Ensure 'Network security: Configure encryption types allowed for Kerberos' is set to 'AES128_HMAC_SHA1, AES256_HMAC_SHA1, Future encryption types'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters"
$regKey = "SupportedEncryptionTypes"
$expectedValue = 2147483640

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (SupportedEncryptionTypes is set to 2147483640, as expected)"
    } else {
        Write-Host "$title - Status: Non-Compliant (SupportedEncryptionTypes is set to $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

