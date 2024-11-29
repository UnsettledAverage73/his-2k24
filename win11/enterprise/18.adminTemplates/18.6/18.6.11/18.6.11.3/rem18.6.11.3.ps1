# remedi.ps1
# Script to enable "Prohibit use of Internet Connection Sharing on your DNS domain network"

# Registry key and desired value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$RegValueName = "NC_ShowSharedAccessUI"
$DesiredValue = 0

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the registry value
Set-ItemProperty -Path $RegPath -Name $RegValueName -Value $DesiredValue -Type DWord

# Verify remediation
$CurrentValue = Get-ItemProperty -Path $RegPath -Name $RegValueName | Select-Object -ExpandProperty $RegValueName -ErrorAction SilentlyContinue
if ($CurrentValue -eq $DesiredValue) {
    Write-Output "Remediation successful: Internet Connection Sharing is prohibited."
} else {
    Write-Output "Remediation failed: $RegValueName is set to $CurrentValue. Expected: $DesiredValue."
}
