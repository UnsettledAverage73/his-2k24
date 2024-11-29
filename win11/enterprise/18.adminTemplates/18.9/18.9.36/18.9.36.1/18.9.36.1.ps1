# check.ps1
# Script to audit the setting of "Enable RPC Endpoint Mapper Client Authentication"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Rpc"
$regValue = "EnableAuthEpResolution"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: 'Enable RPC Endpoint Mapper Client Authentication' is set to Enabled."
        } else {
            Write-Output "FAIL: 'Enable RPC Endpoint Mapper Client Authentication' is set to Disabled."
        }
    } else {
        Write-Output "FAIL: 'Enable RPC Endpoint Mapper Client Authentication' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
