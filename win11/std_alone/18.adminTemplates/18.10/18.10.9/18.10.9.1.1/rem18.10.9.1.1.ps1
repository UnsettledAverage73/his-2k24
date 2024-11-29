# Title: CIS Control 18.10.9.1.1 (BL) - Remediate 'Allow access to BitLocker-protected fixed data drives from earlier versions of Windows'

Write-Host "Remediating: CIS Control 18.10.9.1.1 (BL) - BitLocker Access Restriction"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$regValueName = "FDVDiscoveryVolumeType"

if (-not (Test-Path -Path $regPath)) {
    Write-Host "Creating registry path..." -ForegroundColor Yellow
    New-Item -Path $regPath -Force | Out-Null
}

Remove-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue
Write-Host "Remediated: 'Allow access to BitLocker-protected fixed data drives from earlier versions of Windows' is now set to 'Disabled'." -ForegroundColor Green

