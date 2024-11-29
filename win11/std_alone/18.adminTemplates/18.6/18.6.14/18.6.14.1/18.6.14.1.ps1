# check.ps1
# Script to check if Hardened UNC Paths are configured as recommended

# Registry path and required settings
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\NetworkProvider\HardenedPaths"
$NetlogonValue = "RequireMutualAuthentication=1,RequireIntegrity=1,RequirePrivacy=1"
$SysvolValue = "RequireMutualAuthentication=1,RequireIntegrity=1,RequirePrivacy=1"

# Check if the registry path exists
if (Test-Path $RegPath) {
    # Check NETLOGON path
    $NetlogonCurrent = Get-ItemProperty -Path $RegPath -Name "\\*\NETLOGON" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "\\*\NETLOGON"
    if ($NetlogonCurrent -eq $NetlogonValue) {
        Write-Output "Pass: NETLOGON path is correctly hardened."
    } else {
        Write-Output "Fail: NETLOGON path is not correctly hardened. Current value: $NetlogonCurrent. Expected value: $NetlogonValue."
    }

    # Check SYSVOL path
    $SysvolCurrent = Get-ItemProperty -Path $RegPath -Name "\\*\SYSVOL" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty "\\*\SYSVOL"
    if ($SysvolCurrent -eq $SysvolValue) {
        Write-Output "Pass: SYSVOL path is correctly hardened."
    } else {
        Write-Output "Fail: SYSVOL path is not correctly hardened. Current value: $SysvolCurrent. Expected value: $SysvolValue."
    }
} else {
    Write-Output "Fail: Registry path $RegPath does not exist."
}
