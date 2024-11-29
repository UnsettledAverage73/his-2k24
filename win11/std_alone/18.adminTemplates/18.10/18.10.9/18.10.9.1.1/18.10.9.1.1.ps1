# Title: CIS Control 18.10.9.1.1 (BL) - Check 'Allow access to BitLocker-protected fixed data drives from earlier versions of Windows'

Write-Host "Checking compliance for: CIS Control 18.10.9.1.1 (BL) - BitLocker Access Restriction"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVDiscoveryVolumeType"

if (Test-Path -Path $regPath) {
    $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
    if ([string]::IsNullOrEmpty($currentValue)) {
        Write-Host "Compliant: 'Allow access to BitLocker-protected fixed data drives from earlier versions of Windows' is set to 'Disabled'." -ForegroundColor Green
    } else {
        Write-Host "Non-Compliant: Current value is '$currentValue'. It should be blank (no value)." -ForegroundColor Red
    }
} else {
    Write-Host "Non-Compliant: Registry path not found." -ForegroundColor Red
}

