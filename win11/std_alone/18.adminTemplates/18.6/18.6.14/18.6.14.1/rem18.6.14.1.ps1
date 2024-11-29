# remedi.ps1
# Script to configure Hardened UNC Paths as recommended

# Registry path and required settings
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths"
$NetlogonValue = "RequireMutualAuthentication=1,RequireIntegrity=1,RequirePrivacy=1"
$SysvolValue = "RequireMutualAuthentication=1,RequireIntegrity=1,RequirePrivacy=1"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the NETLOGON path
Set-ItemProperty -Path $RegPath -Name "\\*\NETLOGON" -Value $NetlogonValue -Type String

# Set the SYSVOL path
Set-ItemProperty -Path $RegPath -Name "\\*\SYSVOL" -Value $SysvolValue -Type String

# Verify the remediation
$NetlogonCurrent = Get-ItemProperty -Path $RegPath -Name "\\*\NETLOGON" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "\\*\NETLOGON"
$SysvolCurrent = Get-ItemProperty -Path $RegPath -Name "\\*\SYSVOL" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "\\*\SYSVOL"

if ($NetlogonCurrent -eq $NetlogonValue -and $SysvolCurrent -eq $SysvolValue) {
    Write-Output "Remediation successful: Hardened UNC Paths configured correctly for NETLOGON and SYSVOL."
} else {
    Write-Output "Remediation failed. Please verify the registry settings manually."
}
