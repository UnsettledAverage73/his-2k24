# Title: Audit Script for 'Interactive logon: Message text for users attempting to log on'
# Description: Verifies that the 'Interactive logon: Message text for users attempting to log on' is configured.

Write-Host "Starting Audit: 'Interactive logon: Message text for users attempting to log on' policy" -ForegroundColor Green

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "LegalNoticeText"

try {
    # Check if the registry value exists
    if (Test-Path "$regPath\$regValueName") {
        $regValue = Get-ItemProperty -Path $regPath -Name $regValueName | Select-Object -ExpandProperty $regValueName
        if ($regValue -ne "") {
            Write-Host "PASS: 'Interactive logon: Message text for users attempting to log on' is set." -ForegroundColor Green
        } else {
            Write-Host "FAIL: 'Interactive logon: Message text for users attempting to log on' is empty." -ForegroundColor Red
        }
    } else {
        Write-Host "FAIL: Registry value '$regValueName' does not exist under $regPath." -ForegroundColor Red
    }
} catch {
    Write-Host "ERROR: An error occurred while checking the registry. $_" -ForegroundColor Red
}

Write-Host "Audit Completed." -ForegroundColor Green

