# check.ps1
# Script to audit the setting of "Enable/Disable PerfTrack"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WDI"
$regValue = "{9c5a40da-b965-4fc3-878188dd50a6299d}:ScenarioExecutionEnabled"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: 'Enable/Disable PerfTrack' is set to Disabled."
        } else {
            Write-Output "FAIL: 'Enable/Disable PerfTrack' is not set to Disabled."
        }
    } else {
        Write-Output "FAIL: 'Enable/Disable PerfTrack' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
