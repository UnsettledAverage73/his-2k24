# check.ps1
# Script to audit the setting of "Configure Solicited Remote Assistance"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$regValue = "fAllowToGetHelp"

# Check if the registry path exists
if (Test-Path $regPath) {
    $value = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction SilentlyContinue
    if ($null -ne $value) {
        if ($value.$regValue -eq 0) {
            Write-Output "PASS: 'Configure Solicited Remote Assistance' is set to Disabled."
        } else {
            Write-Output "FAIL: 'Configure Solicited Remote Assistance' is set to Enabled."
        }
    } else {
        Write-Output "FAIL: 'Configure Solicited Remote Assistance' is not configured."
    }
} else {
    Write-Output "FAIL: Registry path for the policy does not exist."
}
