# Title: CIS Control 18.10.8.1.1 (L1) - Check 'Configure Enhanced Anti-Spoofing'

Write-Host "Checking compliance for: CIS Control 18.10.8.1.1 (L1) - Configure Enhanced Anti-Spoofing"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures"
$regValueName = "EnhancedAntiSpoofing"
$expectedValue = 1  # Value for 'Enabled'

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Configure Enhanced Anti-Spoofing' is set to 'Enabled'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue. Expected value is $expectedValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}
