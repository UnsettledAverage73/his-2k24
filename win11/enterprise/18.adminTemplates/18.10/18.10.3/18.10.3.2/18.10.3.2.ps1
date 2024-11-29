# Title: CIS Control 18.10.3.2 (L1) - Check 'Prevent Non-Admin Users from Installing Packaged Windows Apps'

Write-Host "Checking compliance for: CIS Control 18.10.3.2 (L1) - Prevent Non-Admin Users from Installing Packaged Windows Apps"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx"
$regValueName = "BlockNonAdminUserInstall"
$expectedValue = 1

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Prevent Non-Admin Users from Installing Packaged Windows Apps' is Enabled." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

