# Title: CIS Control 18.10.5.2 (L2) - Check 'Block Launching Universal Windows Apps with Windows Runtime API Access from Hosted Content'

Write-Host "Checking compliance for: CIS Control 18.10.5.2 (L2) - Block Universal Windows Apps with Windows Runtime API Access from Hosted Content"

$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "BlockHostedAppAccessWinRT"
$expectedValue = 1

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ($currentValue -eq $expectedValue) {
        Write-Host "Compliant: 'Block Launching Universal Windows Apps with Windows Runtime API Access from Hosted Content' is set to 'Enabled'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is $currentValue." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

