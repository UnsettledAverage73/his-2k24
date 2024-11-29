# Title: CIS Control 18.10.7.1 (L1) - Check 'Disallow Autoplay for Non-Volume Devices'

Write-Host "Checking compliance for: CIS Control 18.10.7.1 (L1) - Disallow Autoplay for Non-Volume Devices"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
$regValueName = "NoAutoplayfornonVolume"
$expectedValue = 1

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Disallow Autoplay for Non-Volume Devices' is set to 'Enabled'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

