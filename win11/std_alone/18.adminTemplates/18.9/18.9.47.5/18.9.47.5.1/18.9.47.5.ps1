# check.ps1
# Script to audit the setting of "Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy"
$regValue = "DisableQueryRemoteServer"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 1) {
            Write-Output "PASS: 'Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider' is set to Disabled."
        } else {
            Write-Output "FAIL: 'Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider' is not set to Disabled."
        }
    } else {
        Write-Output "FAIL: 'Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
