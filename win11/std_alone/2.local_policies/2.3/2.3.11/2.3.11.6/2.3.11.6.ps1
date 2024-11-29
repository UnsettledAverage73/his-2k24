# Check.ps1 - Verify 'Network security: Force logoff when logon hours expire' is set to 'Enabled'

$title = "CIS Control 2.3.11.6 - Ensure 'Network security: Force logoff when logon hours expire' is set to 'Enabled'"

# Define the registry path and key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regKey = "DisableLogoffWhenLogonHoursExpire"
$expectedValue = 0

Write-Host "Checking compliance for: $title"

# Retrieve the current registry value
try {
    $regValue = (Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction Stop).$regKey

    # Check if the registry value matches the expected value
    if ($regValue -eq $expectedValue) {
        Write-Host "$title - Status: Compliant (Force logoff is enabled when logon hours expire)"
    } else {
        Write-Host "$title - Status: Non-Compliant (Value for Force logoff is set to $regValue)"
    }
} catch {
    Write-Host "$title - Status: Non-Compliant (Registry key not found)"
}

