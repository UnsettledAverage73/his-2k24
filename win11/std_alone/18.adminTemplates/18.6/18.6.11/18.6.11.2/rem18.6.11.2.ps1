# remedi.ps1
# Script to enable "Prohibit installation and configuration of Network Bridge on your DNS domain network"

# Registry key and desired value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Network Connections"
$RegValueName = "NC_AllowNetBridge_NLA"
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
    Write-Output "Remediation successful: Network Bridge installation and configuration is prohibited."
} else {
    Write-Output "Remediation failed: $RegValueName is set to $CurrentValue. Expected: $DesiredValue."
}
