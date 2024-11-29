# Title: CIS Control 19.7.5.1 (L1) - Check 'Do not preserve zone information in file attachments'

Write-Host "Checking compliance for: CIS Control 19.7.5.1 (L1) - Do not preserve zone information in file attachments"

$registryBasePath = "HKU:\"
$regSubPath = "Software\Microsoft\Windows\CurrentVersion\Policies\Attachments"
$regValueName = "SaveZoneInformation"
$expectedValue = 2

# Get all user SIDs from the registry
$sidList = Get-ChildItem -Path $registryBasePath | Where-Object { $_.Name -match "^S-1-5-[0-9-]+$" }

if ($sidList) {
    foreach ($sid in $sidList) {
        $regPath = Join-Path -Path $sid.FullName -ChildPath $regSubPath
        if (Test-Path -Path $regPath) {
            $currentValue = (Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue).$regValueName
            if ($currentValue -eq $expectedValue) {
                Write-Host "Compliant for user SID $($sid.Name): 'Do not preserve zone information in file attachments' is set to Disabled." -ForegroundColor Green
            } else {
                Write-Host "Non-Compliant for user SID $($sid.Name): Current value is $currentValue." -ForegroundColor Red
            }
        } else {
            Write-Host "Non-Compliant for user SID $($sid.Name): Registry key not found." -ForegroundColor Red
        }
    }
} else {
    Write-Host "No user SIDs found in the registry." -ForegroundColor Yellow
}

