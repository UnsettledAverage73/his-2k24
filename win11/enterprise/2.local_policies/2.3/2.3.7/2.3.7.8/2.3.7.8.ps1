# Title: Audit Script for 'Interactive logon: Prompt user to change password before expiration'
# Description: Verifies that the 'Interactive logon: Prompt user to change password before expiration' is set to between 5 and 14 days.

Write-Host "Starting Audit: 'Interactive logon: Prompt user to change password before expiration' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regValueName = "PasswordExpiryWarning"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -ge 5 -and $regValue -le 14) {
            Write-Host "PASS: 'Interactive logon: Prompt user to change password before expiration' is set to $regValue days." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Interactive logon: Prompt user to change password before expiration' is set to $regValue days, which is outside the recommended range of 5 to 14 days." -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

